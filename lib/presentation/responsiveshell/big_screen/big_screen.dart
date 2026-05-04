import 'package:chatgptclone/presentation/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class BigScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dashboard(isBigScreen: true);
  }
}