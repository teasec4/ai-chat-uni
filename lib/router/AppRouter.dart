import 'package:chatgptclone/presentation/responsiveshell/responsiveshell.dart';
import 'package:chatgptclone/presentation/settings/settings_screen.dart';

import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => ResponsiveShell(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(),
      )
    ]
  );
}
