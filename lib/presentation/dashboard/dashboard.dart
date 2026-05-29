import 'package:chatgptclone/presentation/dashboard/main/main_screen.dart';
import 'package:chatgptclone/presentation/dashboard/widgets/chat_sidebar.dart';
import 'package:chatgptclone/presentation/responsiveshell/responsiveshell.dart';
import 'package:chatgptclone/presentation/settings/settings_screen.dart';
import 'package:chatgptclone/view_models/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    final chatVM = context.watch<ChatViewModel>();
    final screenSize = BreakpointInfo.of(context);
    final isBigScreen = screenSize != ScreenSize.compact;

    return Scaffold(
      appBar: isBigScreen
          ? null
          : AppBar(
              backgroundColor: Colors.grey[100],
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
                  context.read<ChatViewModel>().selectThread(threadId);
                  Navigator.of(context).pop();
                },
                onNewThread: () {
                  context.read<ChatViewModel>().createThread();
                  Navigator.of(context).pop();
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
                  width: screenSize == ScreenSize.medium ? 280 : 304,
                  threads: chatVM.threads,
                  selectedThreadId: chatVM.selectedThreadId,
                  onThreadSelected: context.read<ChatViewModel>().selectThread,
                  onNewThread: context.read<ChatViewModel>().createThread,
                  onSettingsPressed: _toggleSettings,
                ),
              Expanded(
                child: MainScreen(
                  thread: chatVM.selectedThread,
                  onCreateThread: context.read<ChatViewModel>().createThread,
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
                child: SettingsScreen(
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
