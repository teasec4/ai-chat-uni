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

  static const _icons = [
    Icons.chat_outlined,
    Icons.history_outlined,
    Icons.person_outline,
  ];

  static const _selectedIcons = [
    Icons.chat,
    Icons.history,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final mainScreenVM = Provider.of<MainScreenViewModel>(context);
    final drawerWidth = switch (screenSize) {
      ScreenSize.compact => null,
      ScreenSize.medium => 260.0,
      ScreenSize.expanded => 320.0,
    };
    return Drawer(
      width: drawerWidth,
      child: Container(
        color: Colors.grey[200],
        child: ListView.builder(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final isSelected = i == mainScreenVM.index;
            return ListTile(
              leading: Icon(isSelected ? _selectedIcons[i] : _icons[i]),
              title: Text(items[i]),
              selected: isSelected,
              selectedColor: Colors.blue,
              selectedTileColor: Colors.blue.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () {
                mainScreenVM.setIndex(i);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
