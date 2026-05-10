import 'package:chatgptclone/presentation/dashboard/main/main_screen.dart';
import 'package:chatgptclone/presentation/dashboard/widgets/app_drawer.dart';
import 'package:chatgptclone/presentation/dashboard/widgets/desctop_sidebar.dart';
import 'package:chatgptclone/presentation/dashboard/widgets/list_items.dart';
import 'package:chatgptclone/view_models/main_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  final bool isBigScreen;
  final items = MockListItems();

  Dashboard({required this.isBigScreen, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final mainScreenVM = Provider.of<MainScreenViewModel>(context);
    return Scaffold(
      appBar: widget.isBigScreen
          ? null
          : AppBar(
              backgroundColor: Colors.grey[100],
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
      drawer: AppDrawer(
        items: widget.items.items,
        index: mainScreenVM.index,
        onClick: (index) {
          mainScreenVM.setIndex(index);
          Navigator.of(context).pop();
        },
      ),

      body: Row(
        children: [
          if (widget.isBigScreen)
            DesctopSidebar(
              isCollapsed: _isDrawerOpen,
              selectedIndex: mainScreenVM.index,
              onCollapseTap: () {
                setState(() {
                  _isDrawerOpen = !_isDrawerOpen;
                });
              },
              items: widget.items.items,
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
