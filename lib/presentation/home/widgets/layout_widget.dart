import 'package:chatgptclone/presentation/home/widgets/large_screen.dart';
import 'package:chatgptclone/presentation/home/widgets/small_screen.dart';
import 'package:flutter/material.dart';

class LayoutWidget extends StatefulWidget {
  const LayoutWidget({super.key});

  @override
  State<LayoutWidget> createState() => _LayoutWidgetState();
}

class _LayoutWidgetState extends State<LayoutWidget> {
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const SmallScreen();
        } else {
          return const LargeScreen();
        }
      },
    );
  }
}