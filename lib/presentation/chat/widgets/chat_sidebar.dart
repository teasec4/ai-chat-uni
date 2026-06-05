import 'package:chatgptclone/view_models/chat_view_model.dart';
import 'package:flutter/material.dart';

class ChatSidebar extends StatelessWidget {
  final List<ChatThread> threads;
  final String? selectedThreadId;
  final ValueChanged<String> onThreadSelected;
  final VoidCallback onNewThread;
  final VoidCallback onSettingsPressed;
  final double? width;

  const ChatSidebar({
    super.key,
    required this.threads,
    required this.selectedThreadId,
    required this.onThreadSelected,
    required this.onNewThread,
    required this.onSettingsPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final content = ColoredBox(
      color: const Color(0xFFF3F4F6),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'ChatGPT Clone',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'New chat',
                    child: IconButton(
                      icon: const Icon(Icons.edit_square, size: 20),
                      onPressed: onNewThread,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New chat'),
                  onPressed: onNewThread,
                  style: FilledButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                children: _buildThreadSections(context),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: _SidebarAction(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: onSettingsPressed,
              ),
            ),
          ],
        ),
      ),
    );

    if (width == null) {
      return content;
    }

    return SizedBox(width: width, child: content);
  }

  List<Widget> _buildThreadSections(BuildContext context) {
    final sections = <String, List<ChatThread>>{};
    for (final thread in threads) {
      sections.putIfAbsent(thread.sectionLabel, () => []).add(thread);
    }

    return [
      for (final entry in sections.entries) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
          child: Text(
            entry.key,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        for (final thread in entry.value)
          _ChatThreadTile(
            thread: thread,
            isSelected: thread.id == selectedThreadId,
            onTap: () => onThreadSelected(thread.id),
          ),
      ],
    ];
  }
}

class _ChatThreadTile extends StatelessWidget {
  final ChatThread thread;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChatThreadTile({
    required this.thread,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? Colors.black87 : Colors.grey[850];

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isSelected ? const Color(0xFFE4E7EF) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline, size: 18, color: foreground),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        thread.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: foreground,
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        thread.preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  thread.updatedLabel,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SidebarAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
