import 'package:chatgptclone/presentation/dashboard/main/main_screen.dart';
import 'package:chatgptclone/presentation/dashboard/widgets/app_drawer.dart';
import 'package:chatgptclone/presentation/responsiveshell/responsiveshell.dart';
import 'package:chatgptclone/presentation/settings/settings_screen.dart';
import 'package:chatgptclone/view_models/main_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
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

  static const _destinations = <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.chat_outlined),
      selectedIcon: Icon(Icons.chat),
      label: Text('Chats'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.history_outlined),
      selectedIcon: Icon(Icons.history),
      label: Text('History'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: Text('Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mainScreenVM = Provider.of<MainScreenViewModel>(context);
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
          : AppDrawer(
              items: const ['Chats', 'History', 'Profile'],
              index: mainScreenVM.index,
              screenSize: screenSize,
              onClick: (index) {
                mainScreenVM.setIndex(index);
                Navigator.of(context).pop();
              },
            ),
      body: Stack(
        children: [
          Row(
            children: [
              if (isBigScreen)
                Theme(
                  data: Theme.of(context).copyWith(
                    navigationRailTheme: const NavigationRailThemeData(
                      minWidth: 68,
                      minExtendedWidth: 200,
                    ),
                  ),
                  child: NavigationRail(
                    extended: !_isSidebarCollapsed,
                    selectedIndex: mainScreenVM.index,
                    labelType: _isSidebarCollapsed
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.all,
                    groupAlignment: -1,
                    backgroundColor: Colors.grey[200],
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        setState(() {
                          _isSidebarCollapsed = !_isSidebarCollapsed;
                        });
                      },
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: _toggleSettings,
                      ),
                    ),
                    onDestinationSelected: (index) {
                      mainScreenVM.setIndex(index);
                    },
                    destinations: _destinations,
                  ),
                ),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: MainScreen(index: mainScreenVM.index),
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
