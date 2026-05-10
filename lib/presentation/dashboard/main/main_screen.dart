import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final int index;
  const MainScreen({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: Colors.grey[100],
      child: Center(child: Text('MainScreen $index')),
    );
  }
}
