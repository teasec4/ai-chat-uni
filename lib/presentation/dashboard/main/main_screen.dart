import 'package:chatgptclone/view_models/chat_view_model.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final ChatThread? thread;
  final VoidCallback onCreateThread;

  const MainScreen({
    super.key,
    required this.thread,
    required this.onCreateThread,
  });

  @override
  Widget build(BuildContext context) {
    final activeThread = thread;

    if (activeThread == null) {
      return _EmptyConversation(onCreateThread: onCreateThread);
    }

    return ColoredBox(
      color: const Color(0xFFF7F7F8),
      child: Column(
        children: [
          _ConversationHeader(thread: activeThread),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: activeThread.messages.isEmpty
                    ? const _NoMessages()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                        itemCount: activeThread.messages.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          return _MessageBubble(
                            message: activeThread.messages[index],
                          );
                        },
                      ),
              ),
            ),
          ),
          const _Composer(),
        ],
      ),
    );
  }
}

class _ConversationHeader extends StatelessWidget {
  final ChatThread thread;

  const _ConversationHeader({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.18)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              thread.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            tooltip: 'More',
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatMessageRole.user;
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 620),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: isUser ? theme.colorScheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: isUser
                  ? null
                  : Border.all(color: Colors.grey.withValues(alpha: 0.18)),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 15,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F8),
          border: Border(
            top: BorderSide(color: Colors.grey.withValues(alpha: 0.16)),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: TextField(
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Message ChatGPT Clone',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                suffixIcon: IconButton(
                  tooltip: 'Send',
                  icon: const Icon(Icons.arrow_upward_rounded),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.25),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.22),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoMessages extends StatelessWidget {
  const _NoMessages();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Start a new message when the chat API is connected.',
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  final VoidCallback onCreateThread;

  const _EmptyConversation({required this.onCreateThread});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF7F7F8),
      child: Center(
        child: FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('New chat'),
          onPressed: onCreateThread,
        ),
      ),
    );
  }
}
