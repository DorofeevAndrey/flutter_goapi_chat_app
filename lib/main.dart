import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/themes/theme_provider.dart';
import 'screens/home_page.dart';
import 'screens/initial_page.dart';
import 'services/auth/login_or_register.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final Brightness platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(systemBrightness: platformBrightness),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: '/initial',
      navigatorKey: navigatorKey,
      routes: {
        '/initial': (context) => const InitialPage(),
        '/': (context) => const LoginOrRegister(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
