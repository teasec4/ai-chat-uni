import 'package:chatgptclone/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPanel extends StatelessWidget {
  final VoidCallback onClose;

  const SettingsPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return Container(
      color: Theme.of(context).colorScheme.surface,
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
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark mode'),
              subtitle: const Text('Toggle dark theme'),
              secondary: Icon(
                themeNotifier.isDark ? Icons.dark_mode : Icons.light_mode,
              ),
              value: themeNotifier.isDark,
              onChanged: (_) => themeNotifier.toggle(),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
