import 'package:chatgptclone/presentation/chat/chat_screen.dart';
import 'package:chatgptclone/presentation/shell/breakpoint_info.dart';
import 'package:flutter/material.dart';

class ResponsiveShell extends StatelessWidget {
  const ResponsiveShell({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = constraints.maxWidth < 600
            ? ScreenSize.compact
            : constraints.maxWidth < 900
            ? ScreenSize.medium
            : ScreenSize.expanded;

        return BreakpointInfo(
          screenSize: screenSize,
          child: const ChatScreen(),
        );
      },
    );
  }
}
