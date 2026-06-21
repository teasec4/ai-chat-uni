import 'package:chatgptclone/data/isar_service.dart';
import 'package:chatgptclone/router/app_router.dart';
import 'package:chatgptclone/service/api/chat_completion_service.dart';
import 'package:chatgptclone/view_models/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  void toggle() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  bool get isDark => _mode == ThemeMode.dark;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isarService = IsarService();
  await isarService.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<IsarService>(
          create: (_) => isarService,
          dispose: (_, service) => service.dispose(),
        ),
        Provider<ChatCompletionService>(create: (_) => ChatCompletionService()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(
          create: (context) => ChatViewModel(
            isarService: context.read<IsarService>(),
            chatCompletionService: context.read<ChatCompletionService>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeMode = context.watch<ThemeNotifier>().mode;
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blueAccent,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blueAccent,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: themeMode,
          );
        },
      ),
    ),
  );
}
