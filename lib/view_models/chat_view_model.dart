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
  // mock data for test
  final List<ChatThread> _threads = [
    const ChatThread(
      id: 'desktop-sidebar',
      title: 'Test Thread',
      preview: 'Use a real chat list in the sidebar.',
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
