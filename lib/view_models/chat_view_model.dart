import 'package:chatgptclone/data/isar_service.dart';
import 'package:chatgptclone/data/models/saved_message.dart';
import 'package:chatgptclone/data/models/saved_session.dart';
import 'package:chatgptclone/service/api/chat_complain_service.dart';
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
      title: 'Chat ${_shortSessionId(session.sessionId)}',
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
            : chatMessages.last.text;

        _threads[index] = _threads[index].copyWith(
          preview: preview,
          messages: chatMessages,
        );

        // Persist messages to Isar
        await _isarService.saveMessages(
          threadId,
          _toSavedMessages(threadId, chatMessages),
        );
        // Update thread preview in Isar too
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
    final threadId = session.sessionId;

    try {
      await loadSessions(selectedThreadId: threadId);
    } catch (_) {
      _insertThreadIfMissing(ChatThread.fromSession(session));
      return;
    }

    if (_threads.any((thread) => thread.id == threadId)) return;

    _insertThreadIfMissing(ChatThread.fromSession(session));
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

    _threads[threadIndex] = _threads[threadIndex].copyWith(
      preview: messageText,
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
        _moveThreadId(from: threadId, to: response.sessionId);
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

        _threads[updatedThreadIndex] = _threads[updatedThreadIndex].copyWith(
          preview: response.answer,
          updatedLabel: 'Now',
          messages: [
            ..._threads[updatedThreadIndex].messages,
            assistantMessage,
          ],
        );

        // Persist full conversation to Isar
        await _isarService.saveMessages(
          responseThreadId,
          _toSavedMessages(
            responseThreadId,
            _threads[updatedThreadIndex].messages,
          ),
        );
        await _persistThreadAtIndex(updatedThreadIndex);
      }

      _waitingThreadIds.remove(threadId);
      _waitingThreadIds.remove(responseThreadId);
      _isSendingMessage = false;
      notifyListeners();
    } catch (e) {
      _waitingThreadIds.remove(threadId);
      _isSendingMessage = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // ── Helpers ─────────────────────────────────────────────────

  Future<String> _ensureCurrentSession() async {
    final existingSessionId = _currentSessionId ?? _selectedThreadId;
    if (existingSessionId != null) return existingSessionId;

    final session = await _chatCompletionService.createChat();
    _insertThreadIfMissing(ChatThread.fromSession(session));
    return session.sessionId;
  }

  void _moveThreadId({required String from, required String to}) {
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
        : chatMessages.last.text;

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

String _shortSessionId(String sessionId) {
  if (sessionId.length <= 8) return sessionId;
  return sessionId.substring(0, 8);
}

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
