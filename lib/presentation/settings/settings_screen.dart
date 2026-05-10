import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onClose;
  SettingsScreen({super.key, required this.onClose});

  final mockData = MockData();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(8),
      width: double.infinity,
      child: Center(
        child: Text("Setting"),
      ),
    );
  }
}

class MockData {
  final List<String> settings = ['Dark Mode', 'Language'];
}
