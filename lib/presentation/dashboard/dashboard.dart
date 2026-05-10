import 'package:chatgptclone/presentation/dashboard/main/main_screen.dart';
import 'package:chatgptclone/presentation/dashboard/widgets/app_drawer.dart';
import 'package:chatgptclone/presentation/dashboard/widgets/desctop_sidebar.dart';
import 'package:chatgptclone/presentation/responsiveshell/responsiveshell.dart';
import 'package:chatgptclone/view_models/main_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isSidebarCollapsed = false;
  final items = MockListItems();

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
              items: items.items,
              index: mainScreenVM.index,
              onClick: (index) {
                mainScreenVM.setIndex(index);
                Navigator.of(context).pop();
              },
            ),
      body: Row(
        children: [
          if (isBigScreen)
            DesctopSidebar(
              isCollapsed: _isSidebarCollapsed,
              selectedIndex: mainScreenVM.index,
              onCollapseTap: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
              items: items.items,
            ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: MainScreen(index: mainScreenVM.index),
            ),
          ),
        ],
      ),
    );
  }
}

class MockListItems {
  final List<String> items = ["Item 1", "Item 2", "Item 3"];
}
