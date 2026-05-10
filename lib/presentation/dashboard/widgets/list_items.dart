import 'package:flutter/material.dart';

class ListItems extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;

  final Function(int) onClick;

  const ListItems({
    super.key,
    required this.items,
    required this.onClick,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final isSelected = index == selectedIndex;
        return ListTile(
          title: Text(items[index]),
          selected: isSelected,
          selectedColor: Colors.blue,
          selectedTileColor: Colors.blue.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onTap: () {
            onClick(index);
          },
        );
      },
    );
  }
}
