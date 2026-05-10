import 'package:chatgptclone/router/AppRouter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
    ),
  );
}
