import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'screens/main_shell.dart';
import 'services/socket_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: const BusPIApp(),
    ),
  );
}

class BusPIApp extends StatelessWidget {
  const BusPIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetMyBus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}
