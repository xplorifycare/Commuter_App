import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';
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

class BusPIApp extends StatefulWidget {
  final bool initialOnboarded;

  const BusPIApp({super.key, this.initialOnboarded = false});

  @override
  State<BusPIApp> createState() => _BusPIAppState();
}

class _BusPIAppState extends State<BusPIApp> {
  late bool _onboarded;

  @override
  void initState() {
    super.initState();
    _onboarded = widget.initialOnboarded;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetMyBus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _onboarded
          ? const MainShell()
          : OnboardingScreen(
              onFinish: () {
                setState(() {
                  _onboarded = true;
                });
              },
            ),
    );
  }
}
