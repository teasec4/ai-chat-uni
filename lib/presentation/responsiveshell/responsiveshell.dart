import 'package:chatgptclone/presentation/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

enum ScreenSize { compact, medium, expanded }

class BreakpointInfo extends InheritedWidget {
  final ScreenSize screenSize;

  const BreakpointInfo({
    super.key,
    required this.screenSize,
    required super.child,
  });

  static ScreenSize of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BreakpointInfo>()!
        .screenSize;
  }

  @override
  bool updateShouldNotify(BreakpointInfo oldWidget) =>
      oldWidget.screenSize != screenSize;
}

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
          child: const Dashboard(),
        );
      },
    );
  }
}
