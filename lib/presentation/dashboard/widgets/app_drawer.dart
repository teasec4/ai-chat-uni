import 'package:chatgptclone/presentation/dashboard/widgets/list_items.dart';
import 'package:chatgptclone/presentation/responsiveshell/responsiveshell.dart';
import 'package:chatgptclone/view_models/main_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final List<String> items;
  final int index;
  final ScreenSize screenSize;
  final Function(int) onClick;

  const AppDrawer({
    super.key,
    required this.items,
    required this.index,
    required this.screenSize,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final mainScreenVM = Provider.of<MainScreenViewModel>(context);
    final drawerWidth = switch (screenSize) {
      ScreenSize.compact => null, // default drawer width
      ScreenSize.medium => 260.0,
      ScreenSize.expanded => 320.0,
    };
    return Drawer(
      width: drawerWidth,
      child: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
              child: ListItems(
                items: items,
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
    );
  }
}
