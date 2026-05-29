import 'package:flutter/foundation.dart';

enum ChatMessageRole { user, assistant }

@immutable
class ChatMessage {
  final ChatMessageRole role;
  final String text;

  const ChatMessage({required this.role, required this.text});
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
}

class ChatViewModel extends ChangeNotifier {
  final List<ChatThread> _threads = [
    const ChatThread(
      id: 'desktop-sidebar',
      title: 'Desktop sidebar design',
      preview: 'Turn the rail into a real chat list.',
      sectionLabel: 'Today',
      updatedLabel: 'Now',
      messages: [
        ChatMessage(
          role: ChatMessageRole.user,
          text: 'I want the left side to behave more like ChatGPT.',
        ),
        ChatMessage(
          role: ChatMessageRole.assistant,
          text:
              'Use a custom sidebar for dynamic chats, and keep the main area focused on the selected thread.',
        ),
      ],
    ),
    const ChatThread(
      id: 'ai-memory',
      title: 'AI memory sketch',
      preview: 'Ideas for storing chat context locally.',
      sectionLabel: 'Today',
      updatedLabel: '12m',
      messages: [
        ChatMessage(
          role: ChatMessageRole.user,
          text: 'How should we store local chat history later?',
        ),
        ChatMessage(
          role: ChatMessageRole.assistant,
          text:
              'Start with a thread model, then persist messages once the chat flow is stable.',
        ),
      ],
    ),
    const ChatThread(
      id: 'flutter-layout',
      title: 'Flutter layout notes',
      preview: 'Responsive shell, desktop first.',
      sectionLabel: 'Yesterday',
      updatedLabel: '1d',
      messages: [
        ChatMessage(
          role: ChatMessageRole.user,
          text: 'What should the desktop layout look like?',
        ),
        ChatMessage(
          role: ChatMessageRole.assistant,
          text:
              'A fixed sidebar plus a flexible conversation pane keeps the UI predictable.',
        ),
      ],
    ),
    const ChatThread(
      id: 'profile-settings',
      title: 'Profile and settings',
      preview: 'Keep settings as a side panel for now.',
      sectionLabel: 'Previous 7 days',
      updatedLabel: '4d',
      messages: [
        ChatMessage(
          role: ChatMessageRole.user,
          text: 'Where should settings live?',
        ),
        ChatMessage(
          role: ChatMessageRole.assistant,
          text:
              'Put it at the bottom of the sidebar and open the existing settings panel from there.',
        ),
      ],
    ),
  ];

  String? _selectedThreadId;

  ChatViewModel() {
    if (_threads.isNotEmpty) {
      _selectedThreadId = _threads.first.id;
    }
  }

  List<ChatThread> get threads => List.unmodifiable(_threads);

  String? get selectedThreadId => _selectedThreadId;

  ChatThread? get selectedThread {
    final selectedThreadId = _selectedThreadId;
    if (selectedThreadId == null) return null;

    for (final thread in _threads) {
      if (thread.id == selectedThreadId) return thread;
    }

    return null;
  }

  void selectThread(String id) {
    if (_selectedThreadId == id) return;
    if (!_threads.any((thread) => thread.id == id)) return;

    _selectedThreadId = id;
    notifyListeners();
  }

  void createThread() {
    final thread = ChatThread(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: 'New chat',
      preview: 'No messages yet.',
      sectionLabel: 'Today',
      updatedLabel: 'Now',
      messages: const [],
    );

    _threads.insert(0, thread);
    _selectedThreadId = thread.id;
    notifyListeners();
  }
}
