import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final mockData = MockData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: mockData.settings.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(mockData.settings[index]),
              
            );
          },
        ),
      ),
    );
  }
}

class MockData {
  final List<String> settings = ['Dark Mode', 'Language'];
}
