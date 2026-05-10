import 'package:flutter/material.dart';

class ListItems extends StatelessWidget {
  final List<String> items;

  final Function(int) onClick;
  
  const ListItems({super.key, required this.items, required this.onClick});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
          onTap: () {
            onClick(index);
          },
        );
      },
    );
  }
}
