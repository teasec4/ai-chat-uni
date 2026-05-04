import 'package:chatgptclone/presentation/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class SmallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dashboard(isBigScreen: false);
  }
}
