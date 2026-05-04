import 'package:chatgptclone/presentation/responsiveshell/big_screen/big_screen.dart';
import 'package:chatgptclone/presentation/responsiveshell/small_screen/small_screen.dart';
import 'package:flutter/material.dart';

class ResponsiveShell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return SmallScreen();
        } else {
          return BigScreen();
        }
      },
    );
  }
}