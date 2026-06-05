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
