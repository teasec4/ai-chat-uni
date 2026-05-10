import 'package:chatgptclone/presentation/dashboard/widgets/list_items.dart';
import 'package:chatgptclone/view_models/main_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DesctopSidebar extends StatelessWidget {
  final bool isCollapsed;
  final int selectedIndex;
  final Function() onCollapseTap;
  final List<String> items;
  const DesctopSidebar({super.key, required this.isCollapsed, required this.selectedIndex, required this.onCollapseTap, required this.items});
  @override
  Widget build(BuildContext context) {
    final mainScreenVM = Provider.of<MainScreenViewModel>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: isCollapsed ? 40 : 260,
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: .start,
        children: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: onCollapseTap,
          ),

          const SizedBox(height: 20),

          Expanded(
            child: isCollapsed
            ? Container()
            : ListItems(
                items: items,
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
    );
  }
}