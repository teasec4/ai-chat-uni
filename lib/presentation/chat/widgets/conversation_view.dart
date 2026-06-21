import 'package:chatgptclone/view_models/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;

class ConversationView extends StatefulWidget {
  final ChatThread? thread;
  final bool isLoadingMessages;
  final bool isWaitingForResponse;
  final VoidCallback onCreateThread;
  final VoidCallback onCancelResponse;
  final ValueChanged<String> onSendMessage;
  final void Function(int messageIndex, String newText) onEditMessage;

  const ConversationView({
    super.key,
    required this.thread,
    this.isLoadingMessages = false,
    this.isWaitingForResponse = false,
    required this.onCreateThread,
    required this.onCancelResponse,
    required this.onSendMessage,
    required this.onEditMessage,
  });

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final ScrollController _scrollController = ScrollController();
  int? _editingIndex;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant ConversationView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Scroll when messages grow (new message added or response arrives)
    final oldLen = oldWidget.thread?.messages.length ?? 0;
    final newLen = widget.thread?.messages.length ?? 0;
    if (newLen > oldLen) {
      _scrollToBottom();
    }
    // Scroll when response finishes (spinner disappears)
    if (oldWidget.isWaitingForResponse && !widget.isWaitingForResponse) {
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeThread = widget.thread;

    if (activeThread == null) {
      return ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            Expanded(
              child: _EmptyState(
                onCreateThread: widget.onCreateThread,
                onSendMessage: widget.onSendMessage,
              ),
            ),
            _Composer(
              isWaitingForResponse: false,
              onSendMessage: widget.onSendMessage,
              onCancelResponse: widget.onCancelResponse,
            ),
          ],
        ),
      );
    }

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          _ConversationHeader(thread: activeThread),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: widget.isLoadingMessages
                    ? const _LoadingMessages()
                    : activeThread.messages.isEmpty &&
                          !widget.isWaitingForResponse
                    ? const _NoMessages()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                        itemCount:
                            activeThread.messages.length +
                            (widget.isWaitingForResponse ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == activeThread.messages.length) {
                            return const _AssistantThinkingBubble();
                          }

                          final msg = activeThread.messages[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _MessageBubble(
                              message: msg,
                              isEditing: _editingIndex == index,
                              onStartEdit: msg.role == ChatMessageRole.user
                                  ? () => setState(() => _editingIndex = index)
                                  : null,
                              onCancelEdit: () =>
                                  setState(() => _editingIndex = null),
                              onSaveEdit: (newText) {
                                setState(() => _editingIndex = null);
                                widget.onEditMessage(index, newText);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
          _Composer(
            isWaitingForResponse: widget.isWaitingForResponse,
            onSendMessage: widget.onSendMessage,
            onCancelResponse: widget.onCancelResponse,
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────

class _ConversationHeader extends StatelessWidget {
  final ChatThread thread;
  const _ConversationHeader({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
        ],
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isEditing;
  final VoidCallback? onStartEdit;
  final VoidCallback? onCancelEdit;
  final ValueChanged<String>? onSaveEdit;

  const _MessageBubble({
    required this.message,
    this.isEditing = false,
    this.onStartEdit,
    this.onCancelEdit,
    this.onSaveEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatMessageRole.user;
    final theme = Theme.of(context);

    if (isUser && isEditing) {
      return _EditBubble(
        initialText: message.text,
        onCancel: onCancelEdit,
        onSave: onSaveEdit,
      );
    }

    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: GestureDetector(
            onLongPress: onStartEdit,
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
              child: isUser
                  ? Text(
                      message.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    )
                  : MarkdownBody(
                      data: message.text,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 15, height: 1.35),
                        code: TextStyle(
                          fontSize: 13,
                          backgroundColor: Colors.grey[200],
                          color: const Color(0xFFD4D4D4),
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        codeblockPadding: const EdgeInsets.all(12),
                      ),
                      builders: {'code': _CodeBlockBuilder()},
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Edit bubble ───────────────────────────────────────────────

class _EditBubble extends StatefulWidget {
  final String initialText;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onSave;

  const _EditBubble({required this.initialText, this.onCancel, this.onSave});

  @override
  State<_EditBubble> createState() => _EditBubbleState();
}

class _EditBubbleState extends State<_EditBubble> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 620),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 5,
            minLines: 1,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => widget.onSave?.call(_controller.text.trim()),
                child: const Text('Save & Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Composer ──────────────────────────────────────────────────

class _Composer extends StatefulWidget {
  final bool isWaitingForResponse;
  final ValueChanged<String> onSendMessage;
  final VoidCallback onCancelResponse;

  const _Composer({
    required this.isWaitingForResponse,
    required this.onSendMessage,
    required this.onCancelResponse,
  });

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTextChanged)
      ..dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {});
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isWaitingForResponse) return;

    widget.onSendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final canSend =
        _controller.text.trim().isNotEmpty && !widget.isWaitingForResponse;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: Colors.grey.withValues(alpha: 0.16)),
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Row(
              children: [
                if (widget.isWaitingForResponse)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton.filled(
                      tooltip: 'Stop generating',
                      icon: const Icon(Icons.stop, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: widget.onCancelResponse,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !widget.isWaitingForResponse,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {
                      if (canSend) _submit();
                    },
                    decoration: InputDecoration(
                      hintText: 'Message ChatGPT Clone',
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                      suffixIcon: IconButton(
                        tooltip: 'Send',
                        icon: const Icon(Icons.arrow_upward_rounded),
                        onPressed: canSend ? _submit : null,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Code block with copy ──────────────────────────────────────

class _CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;
    return Stack(
      children: [
        // The default code rendering is handled by MarkdownBody, we just add
        // a copy button overlay.
        Positioned(top: 4, right: 4, child: _CopyButton(text: code)),
      ],
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String text;
  const _CopyButton({required this.text});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: _copy,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            _copied ? Icons.check : Icons.copy,
            size: 16,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }
}

// ── Loading / Empty / Thinking ───────────────────────────────

class _AssistantThinkingBubble extends StatelessWidget {
  const _AssistantThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 620),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.18)),
          ),
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      ],
    );
  }
}

class _LoadingMessages extends StatelessWidget {
  const _LoadingMessages();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
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

// ── Empty state ───────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateThread;
  final ValueChanged<String> onSendMessage;
  const _EmptyState({
    required this.onCreateThread,
    required this.onSendMessage,
  });

  static const _suggestions = [
    'Explain quantum computing in simple terms',
    'Write a Python script to sort a CSV file',
    'Draft an email for a job application',
    'What are the key differences between REST and GraphQL?',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'How can I help you today?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                for (final suggestion in _suggestions)
                  ActionChip(
                    avatar: Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    label: SizedBox(
                      width: 220,
                      child: Text(
                        suggestion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    onPressed: () => onSendMessage(suggestion),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
