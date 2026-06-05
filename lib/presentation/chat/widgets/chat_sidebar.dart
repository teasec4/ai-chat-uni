import 'package:chatgptclone/view_models/chat_view_model.dart';
import 'package:flutter/material.dart';

class ChatSidebar extends StatelessWidget {
  final List<ChatThread> threads;
  final String? selectedThreadId;
  final ValueChanged<String> onThreadSelected;
  final VoidCallback onNewThread;
  final VoidCallback onSettingsPressed;
  final double? width;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapsed;

  const ChatSidebar({
    super.key,
    required this.threads,
    required this.selectedThreadId,
    required this.onThreadSelected,
    required this.onNewThread,
    required this.onSettingsPressed,
    this.width,
    this.isCollapsed = false,
    this.onToggleCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return _SidebarFrame(
        width: width,
        child: _CollapsedSidebarContent(
          onToggleCollapsed: onToggleCollapsed,
          onNewThread: onNewThread,
          onSettingsPressed: onSettingsPressed,
        ),
      );
    }

    final toggleButton = onToggleCollapsed == null
        ? const SizedBox.shrink()
        : Tooltip(
            message: 'Collapse sidebar',
            child: IconButton(
              icon: const Icon(Icons.keyboard_double_arrow_left, size: 20),
              onPressed: onToggleCollapsed,
            ),
          );

    final content = ColoredBox(
      color: const Color(0xFFF3F4F6),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  toggleButton,
                  const Spacer(),
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                children: _buildThreadSections(context),
              ),
            ),

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

    return _SidebarFrame(width: width, child: content);
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

class _SidebarFrame extends StatelessWidget {
  final double? width;
  final Widget child;

  const _SidebarFrame({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    if (width == null) return child;

    return SizedBox(width: width, child: child);
  }
}

class _CollapsedSidebarContent extends StatelessWidget {
  final VoidCallback? onToggleCollapsed;
  final VoidCallback onNewThread;
  final VoidCallback onSettingsPressed;

  const _CollapsedSidebarContent({
    required this.onToggleCollapsed,
    required this.onNewThread,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF3F4F6),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
              child: Column(
                children: [
                  Tooltip(
                    message: 'Expand sidebar',
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_double_arrow_right),
                      onPressed: onToggleCollapsed,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
              child: Tooltip(
                message: 'Settings',
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: onSettingsPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
