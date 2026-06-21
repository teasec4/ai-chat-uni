import 'package:chatgptclone/data/isar_service.dart';
import 'package:chatgptclone/data/models/saved_message.dart';
import 'package:chatgptclone/data/models/saved_session.dart';
import 'package:chatgptclone/service/api/chat_completion_service.dart';
import 'package:flutter/foundation.dart';

enum ChatMessageRole { user, assistant }

@immutable
class ChatMessage {
  final ChatMessageRole role;
  final String text;

  const ChatMessage({required this.role, required this.text});

  factory ChatMessage.fromResponse(ChatMessageResponse response) {
    return ChatMessage(role: _roleFromApi(response.role), text: response.text);
  }

  factory ChatMessage.fromSaved(SavedMessage saved) {
    return ChatMessage(role: _roleFromApi(saved.role), text: saved.text);
  }
}

@immutable
class ChatThread {
  final String id;
  final String title;
  final String preview;
  final String sectionLabel;
  final String updatedLabel;
  final List<ChatMessage> messages;

  const ChatThread({
    required this.id,
    required this.title,
    required this.preview,
    required this.sectionLabel,
    required this.updatedLabel,
    required this.messages,
  });

  factory ChatThread.empty(String id) {
    return ChatThread(
      id: id,
      title: 'New chat',
      preview: 'No messages yet.',
      sectionLabel: 'Today',
      updatedLabel: 'Now',
      messages: const [],
    );
  }

  factory ChatThread.fromSession(ChatSessionResponse session) {
    return ChatThread(
      id: session.sessionId,
      title: 'New chat',
      preview: session.messageCount == 0
          ? 'No messages yet.'
          : '${session.messageCount} messages',
      sectionLabel: 'Today',
      updatedLabel: _formatUpdatedLabel(session.updatedAt ?? session.createdAt),
      messages: const [],
    );
  }

  factory ChatThread.fromSavedSession(SavedSession saved) {
    return ChatThread(
      id: saved.sessionId,
      title: saved.title,
      preview: saved.preview,
      sectionLabel: saved.sectionLabel,
      updatedLabel: saved.updatedLabel,
      messages: const [],
    );
  }

  ChatThread copyWith({
    String? title,
    String? preview,
    String? sectionLabel,
    String? updatedLabel,
    List<ChatMessage>? messages,
  }) {
    return ChatThread(
      id: id,
      title: title ?? this.title,
      preview: preview ?? this.preview,
      sectionLabel: sectionLabel ?? this.sectionLabel,
      updatedLabel: updatedLabel ?? this.updatedLabel,
      messages: messages ?? this.messages,
    );
  }
}

class ChatViewModel extends ChangeNotifier {
  final List<ChatThread> _threads = [];

  final IsarService _isarService;
  final ChatCompletionService _chatCompletionService;

  String? _selectedThreadId;
  String? _currentSessionId;
  bool _isLoadingSessions = false;
  bool _isLoadingMessages = false;
  bool _isSendingMessage = false;
  final Set<String> _waitingThreadIds = <String>{};
  String? _errorMessage;

  ChatViewModel({
    required IsarService isarService,
    required ChatCompletionService chatCompletionService,
  }) : _isarService = isarService,
       _chatCompletionService = chatCompletionService;

  List<ChatThread> get threads => List.unmodifiable(_threads);

  String? get selectedThreadId => _selectedThreadId;

  String? get currentSessionId => _currentSessionId;

  bool get isLoadingSessions => _isLoadingSessions;

  bool get isLoadingMessages => _isLoadingMessages;

  bool get isWaitingForResponse {
    final selectedThreadId = _selectedThreadId;
    return _isSendingMessage ||
        selectedThreadId != null &&
            _waitingThreadIds.contains(selectedThreadId);
  }

  String? get errorMessage => _errorMessage;

  ChatThread? get selectedThread {
    final selectedThreadId = _selectedThreadId;
    if (selectedThreadId == null) return null;

    for (final thread in _threads) {
      if (thread.id == selectedThreadId) return thread;
    }

    return null;
  }

  // ── Local boot ──────────────────────────────────────────────

  /// Load sessions from Isar first for instant UI, then sync with API.
  Future<void> loadFromCache() async {
    final saved = await _isarService.loadAllSessions();
    if (saved.isEmpty) return;

    _threads.clear();
    _threads.addAll(saved.map(ChatThread.fromSavedSession));
    notifyListeners();
  }

  // ── Remote sync ─────────────────────────────────────────────

  Future<void> loadSessions({String? selectedThreadId}) async {
    if (_isLoadingSessions) return;

    final threadIdToKeep = selectedThreadId ?? _currentSessionId;

    _isLoadingSessions = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final sessions = await _chatCompletionService.getSessions();
      final loadedThreads = sessions.map(ChatThread.fromSession).toList();

      // Preserve locally-stored titles when merging with API data
      for (final loaded in loadedThreads) {
        final cached = _threads.cast<ChatThread?>().firstWhere(
          (t) => t?.id == loaded.id,
          orElse: () => null,
        );
        if (cached != null && cached.title != 'New chat') {
          final idx = loadedThreads.indexWhere((t) => t.id == loaded.id);
          loadedThreads[idx] = loaded.copyWith(
            title: cached.title,
            preview: cached.preview,
          );
        }
      }

      _threads
        ..clear()
        ..addAll(loadedThreads);

      _selectedThreadId =
          threadIdToKeep != null &&
              _threads.any((thread) => thread.id == threadIdToKeep)
          ? threadIdToKeep
          : null;
      _currentSessionId = _selectedThreadId;

      // Persist to Isar
      await _persistThreads();

      _isLoadingSessions = false;
      notifyListeners();
    } catch (e) {
      _isLoadingSessions = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> selectThread(String id) async {
    if (_selectedThreadId == id) return;
    if (!_threads.any((thread) => thread.id == id)) return;

    _selectedThreadId = id;
    _currentSessionId = id;
    notifyListeners();

    // Try cache first
    final cachedMessages = await _isarService.loadMessages(id);
    if (cachedMessages.isNotEmpty) {
      _applyCachedMessages(id, cachedMessages);
    }

    // Then fetch fresh from API
    await loadMessages(id);
  }

  Future<void> loadMessages(String threadId) async {
    if (_isLoadingMessages) return;

    _isLoadingMessages = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final messages = await _chatCompletionService.getChatHistory(threadId);
      final index = _threads.indexWhere((thread) => thread.id == threadId);

      if (index != -1) {
        final chatMessages = messages.map(ChatMessage.fromResponse).toList();
        final preview = chatMessages.isEmpty
            ? 'No messages yet.'
            : _trimPreview(chatMessages.last.text);

        _threads[index] = _threads[index].copyWith(
          preview: preview,
          messages: chatMessages,
        );

        // Persist messages to Isar
        await _isarService.saveMessages(
          threadId,
          _toSavedMessages(threadId, chatMessages),
        );
        await _persistThreadAtIndex(index);
      }

      _isLoadingMessages = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMessages = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> createThread() async {
    final session = await _chatCompletionService.createChat();

    try {
      await loadSessions(selectedThreadId: session.sessionId);
    } catch (_) {
      _insertThreadIfMissing(ChatThread.fromSession(session));
    }
  }

  Future<void> sendMessage(String text) async {
    final messageText = text.trim();

    if (messageText.isEmpty || _isSendingMessage) {
      return;
    }

    _isSendingMessage = true;
    _errorMessage = null;
    notifyListeners();

    final threadId = await _ensureCurrentSession();
    if (_waitingThreadIds.contains(threadId)) {
      _isSendingMessage = false;
      notifyListeners();
      return;
    }

    final threadIndex = _threads.indexWhere((thread) => thread.id == threadId);
    if (threadIndex == -1) return;

    final userMessage = ChatMessage(
      role: ChatMessageRole.user,
      text: messageText,
    );

    // Auto-title: use first user message as chat title
    final needsTitle = _threads[threadIndex].title == 'New chat';

    _threads[threadIndex] = _threads[threadIndex].copyWith(
      preview: _trimPreview(messageText),
      updatedLabel: 'Now',
      messages: [..._threads[threadIndex].messages, userMessage],
    );
    _waitingThreadIds.add(threadId);
    _isSendingMessage = false;
    notifyListeners();

    try {
      final response = await _chatCompletionService.complete(
        ChatCompletion(sessionId: threadId, message: messageText),
      );

      _currentSessionId = response.sessionId;
      _selectedThreadId = response.sessionId;

      if (response.sessionId != threadId) {
        await _moveThreadId(from: threadId, to: response.sessionId);
      }

      final responseThreadId = response.sessionId;
      final updatedThreadIndex = _threads.indexWhere(
        (thread) => thread.id == responseThreadId,
      );
      if (updatedThreadIndex != -1) {
        final assistantMessage = ChatMessage(
          role: ChatMessageRole.assistant,
          text: response.answer,
        );

        final preview = _trimPreview(response.answer);
        final title = needsTitle ? _makeTitle(messageText) : null;

        _threads[updatedThreadIndex] = _threads[updatedThreadIndex].copyWith(
          title: title ?? _threads[updatedThreadIndex].title,
          preview: preview,
          updatedLabel: 'Now',
          messages: [
            ..._threads[updatedThreadIndex].messages,
            assistantMessage,
          ],
        );

        // Persist full conversation to Isar (best-effort, don't break the UI)
        _persistConversation(responseThreadId, updatedThreadIndex);
      }

      _waitingThreadIds.remove(threadId);
      _waitingThreadIds.remove(responseThreadId);
      _isSendingMessage = false;
      notifyListeners();
    } catch (e) {
      _waitingThreadIds.remove(threadId);
      _isSendingMessage = false;

      // Don't treat cancellation as an error
      if (!_isCancellationError(e)) {
        _errorMessage = e.toString();
      }
      notifyListeners();
      rethrow;
    }
  }

  // ── Edit + resend ───────────────────────────────────────────

  Future<void> editAndResend(int messageIndex, String newText) async {
    final threadId = _selectedThreadId;
    if (threadId == null) return;

    final index = _threads.indexWhere((thread) => thread.id == threadId);
    if (index == -1) return;

    final thread = _threads[index];
    if (messageIndex < 0 || messageIndex >= thread.messages.length) return;

    // Truncate to before the edited message, replace it
    final truncated = thread.messages.sublist(0, messageIndex);
    truncated.add(ChatMessage(role: ChatMessageRole.user, text: newText));

    _threads[index] = thread.copyWith(messages: truncated);
    notifyListeners();

    // Resend the edited message
    await sendMessage(newText);
  }

  // ── Cancel ──────────────────────────────────────────────────

  void cancelResponse() {
    if (_waitingThreadIds.isEmpty) return;

    _chatCompletionService.cancel();
    _waitingThreadIds.clear();
    _isSendingMessage = false;
    notifyListeners();
  }

  // ── Delete ──────────────────────────────────────────────────

  Future<void> deleteThread(String id) async {
    final index = _threads.indexWhere((thread) => thread.id == id);
    if (index == -1) return;

    _threads.removeAt(index);

    if (_selectedThreadId == id) {
      _selectedThreadId = null;
      _currentSessionId = null;
    }

    notifyListeners();

    try {
      await _isarService.deleteSession(id);
    } catch (_) {}
  }

  // ── Helpers ─────────────────────────────────────────────────

  Future<String> _ensureCurrentSession() async {
    final existingSessionId = _currentSessionId ?? _selectedThreadId;
    if (existingSessionId != null) return existingSessionId;

    final session = await _chatCompletionService.createChat();
    _insertThreadIfMissing(ChatThread.fromSession(session));
    return session.sessionId;
  }

  Future<void> _moveThreadId({required String from, required String to}) async {
    if (from == to) return;

    final existingIndex = _threads.indexWhere((thread) => thread.id == from);
    if (existingIndex == -1) return;

    final existingThread = _threads[existingIndex];
    _threads[existingIndex] = ChatThread(
      id: to,
      title: existingThread.title,
      preview: existingThread.preview,
      sectionLabel: existingThread.sectionLabel,
      updatedLabel: existingThread.updatedLabel,
      messages: existingThread.messages,
    );

    // Persist new id, clean up old record in Isar
    try {
      await _persistThreadAtIndex(existingIndex);
      await _isarService.deleteSession(from);
    } catch (_) {
      // Best-effort: UI state is already correct
    }
  }

  void _insertThreadIfMissing(ChatThread thread) {
    if (!_threads.any((existingThread) => existingThread.id == thread.id)) {
      _threads.insert(0, thread);
    }

    _selectedThreadId = thread.id;
    _currentSessionId = thread.id;
    notifyListeners();
  }

  void _applyCachedMessages(
    String sessionId,
    List<SavedMessage> cachedMessages,
  ) {
    final index = _threads.indexWhere((thread) => thread.id == sessionId);
    if (index == -1) return;

    final chatMessages = cachedMessages.map(ChatMessage.fromSaved).toList();
    final preview = chatMessages.isEmpty
        ? 'No messages yet.'
        : _trimPreview(chatMessages.last.text);

    _threads[index] = _threads[index].copyWith(
      preview: preview,
      messages: chatMessages,
    );
    notifyListeners();
  }

  Future<void> _persistThreads() async {
    final sessions = _threads.map(_toSavedSession).toList();
    await _isarService.saveSessions(sessions);
  }

  Future<void> _persistThreadAtIndex(int index) async {
    if (index < 0 || index >= _threads.length) return;
    await _isarService.saveSession(_toSavedSession(_threads[index]));
  }

  void _persistConversation(String sessionId, int threadIndex) {
    // Fire-and-forget: Isar errors must not surface to the user
    Future.microtask(() async {
      try {
        await _isarService.saveMessages(
          sessionId,
          _toSavedMessages(sessionId, _threads[threadIndex].messages),
        );
        await _persistThreadAtIndex(threadIndex);
      } catch (_) {}
    });
  }

  SavedSession _toSavedSession(ChatThread thread) {
    return SavedSession()
      ..sessionId = thread.id
      ..title = thread.title
      ..preview = thread.preview
      ..sectionLabel = thread.sectionLabel
      ..updatedLabel = thread.updatedLabel
      ..messageCount = thread.messages.length;
  }

  List<SavedMessage> _toSavedMessages(
    String sessionId,
    List<ChatMessage> messages,
  ) {
    return [
      for (var i = 0; i < messages.length; i++)
        SavedMessage()
          ..sessionId = sessionId
          ..role = messages[i].role.name
          ..text = messages[i].text
          ..sortOrder = i,
    ];
  }
}

// ── Utilities ───────────────────────────────────────────────────

String _formatUpdatedLabel(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return 'Now';

  final parsedDate = DateTime.tryParse(rawDate);
  if (parsedDate == null) return 'Now';

  final localDate = parsedDate.toLocal();
  final now = DateTime.now();
  final isToday =
      localDate.year == now.year &&
      localDate.month == now.month &&
      localDate.day == now.day;

  if (isToday) return 'Today';

  final difference = now.difference(localDate);
  if (difference.inDays == 1) return 'Yesterday';
  if (difference.inDays < 7) return '${difference.inDays}d';

  return '${localDate.month}/${localDate.day}';
}

ChatMessageRole _roleFromApi(String role) {
  final normalizedRole = role.toLowerCase();

  if (normalizedRole == 'assistant' ||
      normalizedRole == 'bot' ||
      normalizedRole == 'model') {
    return ChatMessageRole.assistant;
  }

  return ChatMessageRole.user;
}

/// Strip markdown to a single plain-text line for sidebar previews.
String _trimPreview(String text) {
  final cleaned = text
      .replaceAll(RegExp(r'```[\s\S]*?```'), '[code]')
      .replaceAll(RegExp(r'[*_~`>#\[\]]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return cleaned.length > 100 ? '${cleaned.substring(0, 97)}...' : cleaned;
}

/// First line of the first user message, capped at 40 chars.
String _makeTitle(String text) {
  final line = text.split('\n').first.trim();
  return line.length > 40 ? '${line.substring(0, 37)}...' : line;
}

bool _isCancellationError(Object e) {
  final msg = e.toString().toLowerCase();
  return msg.contains('cancel') ||
      msg.contains('closed') ||
      msg.contains('connection closed');
}
