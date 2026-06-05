import 'package:chatgptclone/presentation/shell/responsive_shell.dart';
import 'package:chatgptclone/presentation/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const ResponsiveShell()),
    ],
  );
}
