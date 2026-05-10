import 'package:chatgptclone/presentation/dashboard/main/screens/first_screen.dart';
import 'package:chatgptclone/presentation/dashboard/main/screens/second_screen.dart';
import 'package:chatgptclone/presentation/dashboard/main/screens/third_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final int index;
  const MainScreen({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildScreen(index),
    );
  }

  Widget _buildScreen(int index) {
    switch(index){
      case 0:
        return FirstScreen();
      case 1:
        return SecondScreen();
      case 2:
        return ThirdScreen();
      default:
        return  SizedBox.shrink();
    }
  }
}
