import 'package:chatgptclone/presentation/shell/responsive_shell.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const ResponsiveShell()),
    ],
  );
}
