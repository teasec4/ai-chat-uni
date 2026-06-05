import 'package:flutter/material.dart';

class SettingsPanel extends StatelessWidget {
  final VoidCallback onClose;

  const SettingsPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: 'Close settings',
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const Expanded(child: Center(child: Text('Settings'))),
          ],
        ),
      ),
    );
  }
}
