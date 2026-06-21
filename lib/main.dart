import 'package:chatgptclone/data/isar_service.dart';
import 'package:chatgptclone/router/app_router.dart';
import 'package:chatgptclone/service/api/chat_complain_service.dart';
import 'package:chatgptclone/view_models/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(
          create: (context) => ChatViewModel(
            isarService: context.read<IsarService>(),
            chatCompletionService: context.read<ChatCompletionService>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        ),
      ),
    ),
  );
}
