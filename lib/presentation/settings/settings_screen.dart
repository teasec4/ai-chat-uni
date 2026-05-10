import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final mockData = MockData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.grey[100],
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            for (var setting in mockData.settings)
              Text(
                setting,
              ),
          ],
        )
        
      ),
    );
  }
}

class MockData {
  final List<String> settings = ['Dark Mode', 'Language'];
}
