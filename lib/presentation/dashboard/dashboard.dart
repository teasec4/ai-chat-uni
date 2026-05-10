import 'package:chatgptclone/presentation/dashboard/main/main_screen.dart';
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
      drawer: Drawer(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Expanded(
                child: ListItems(
                  items: widget.items.items,
                  onClick: (index) {
                    print(index);
                    mainScreenVM.setIndex(index);
                    Navigator.of(context).pop();
                  },
                  selectedIndex: mainScreenVM.index,
                ),
              ),
            ],
          ),
        ),
      ),

      body: Row(
        children: [
          if (widget.isBigScreen)
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: _isDrawerOpen ? 72 : 260,
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: _isDrawerOpen
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        _isDrawerOpen = !_isDrawerOpen;
                      });
                    },
                  ),

                  SizedBox(height: 20),

                  Expanded(
                    child: _isDrawerOpen
                        ? Container()
                        : ListItems(
                            items: widget.items.items,
                            onClick: (index) {
                              print(index);
                              mainScreenVM.setIndex(index);
                            },
                            selectedIndex: mainScreenVM.index,
                          ),
                  ),

                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      GoRouter.of(context).push("/settings");
                    },
                  ),
                ],
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
    );
  }
}

class MockListItems {
  final List<String> items = ["Item 1", "Item 2", "Item 3"];
}
