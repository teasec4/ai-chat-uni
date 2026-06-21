import 'package:chatgptclone/presentation/chat/widgets/chat_sidebar.dart';
import 'package:chatgptclone/presentation/chat/widgets/conversation_view.dart';
import 'package:chatgptclone/presentation/settings/settings_panel.dart';
import 'package:chatgptclone/presentation/shell/breakpoint_info.dart';
import 'package:chatgptclone/view_models/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  bool _isSidebarCollapsed = false;
  bool _isShowSettings = false;

  late final AnimationController _settingsSlide;

  @override
  void initState() {
    super.initState();
    _settingsSlide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _settingsSlide.dispose();
    super.dispose();
  }

  void _toggleSettings() {
    if (_isShowSettings) {
      _settingsSlide.reverse().then((_) {
        if (mounted) setState(() => _isShowSettings = false);
      });
    } else {
      setState(() => _isShowSettings = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _settingsSlide.forward();
      });
    }
  }

  Future<void> _createThread({bool closeDrawer = false}) async {
    if (closeDrawer) Navigator.of(context).pop();

    try {
      await context.read<ChatViewModel>().createThread();
    } catch (error) {
      if (!mounted) return;
      _showError('Could not create chat', error);
    }
  }

  Future<void> _selectThread(
    String threadId, {
    bool closeDrawer = false,
  }) async {
    if (closeDrawer) Navigator.of(context).pop();

    try {
      await context.read<ChatViewModel>().selectThread(threadId);
    } catch (error) {
      if (!mounted) return;
      _showError('Could not load chat history', error);
    }
  }

  Future<void> _sendMessage(String message) async {
    try {
      await context.read<ChatViewModel>().sendMessage(message);
    } catch (error) {
      if (!mounted) return;
      _showError('Could not send message', error);
    }
  }

  void _cancelResponse() {
    context.read<ChatViewModel>().cancelResponse();
  }

  Future<void> _deleteThread(String id) async {
    try {
      await context.read<ChatViewModel>().deleteThread(id);
    } catch (error) {
      if (!mounted) return;
      _showError('Could not delete chat', error);
    }
  }

  void _editMessage(int index, String newText) {
    context.read<ChatViewModel>().editAndResend(index, newText.trim());
  }

  void _showError(String message, Object error) {
    _showNotice(
      icon: Icons.error_outline,
      message: '$message: ${_readableError(error)}',
      backgroundColor: const Color(0xFFB91C1C),
    );
  }

  void _showNotice({
    required IconData icon,
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  String _readableError(Object error) {
    final message = error.toString();
    return message.replaceFirst(RegExp(r'^Exception: '), '');
  }

  @override
  Widget build(BuildContext context) {
    final chatVM = context.watch<ChatViewModel>();
    final screenSize = BreakpointInfo.of(context);
    final isBigScreen = screenSize != ScreenSize.compact;

    return Scaffold(
      appBar: isBigScreen
          ? null
          : AppBar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerLow,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
      drawer: isBigScreen
          ? null
          : Drawer(
              child: ChatSidebar(
                threads: chatVM.threads,
                selectedThreadId: chatVM.selectedThreadId,
                onThreadSelected: (threadId) {
                  _selectThread(threadId, closeDrawer: true);
                },
                onNewThread: () {
                  _createThread(closeDrawer: true);
                },
                onDeleteThread: (threadId) {
                  _deleteThread(threadId);
                },
                onSettingsPressed: () {
                  Navigator.of(context).pop();
                  _toggleSettings();
                },
              ),
            ),
      body: Stack(
        children: [
          Row(
            children: [
              if (isBigScreen)
                ChatSidebar(
                  width: _isSidebarCollapsed
                      ? 64
                      : screenSize == ScreenSize.medium
                      ? 280
                      : 304,
                  isCollapsed: _isSidebarCollapsed,
                  threads: chatVM.threads,
                  selectedThreadId: chatVM.selectedThreadId,
                  onThreadSelected: _selectThread,
                  onNewThread: _createThread,
                  onDeleteThread: _deleteThread,
                  onSettingsPressed: _toggleSettings,
                  onToggleCollapsed: () {
                    setState(() {
                      _isSidebarCollapsed = !_isSidebarCollapsed;
                    });
                  },
                ),
              Expanded(
                child: ConversationView(
                  thread: chatVM.selectedThread,
                  isLoadingMessages: chatVM.isLoadingMessages,
                  isWaitingForResponse: chatVM.isWaitingForResponse,
                  onCreateThread: _createThread,
                  onCancelResponse: _cancelResponse,
                  onSendMessage: _sendMessage,
                  onEditMessage: _editMessage,
                ),
              ),
            ],
          ),

          if (_isShowSettings)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: screenSize == ScreenSize.medium ? 320 : 400,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1, 0),
                  end: Offset.zero,
                ).animate(_settingsSlide),
                child: SettingsPanel(
                  onClose: () {
                    _toggleSettings();
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
