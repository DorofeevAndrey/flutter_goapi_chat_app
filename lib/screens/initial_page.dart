import 'package:flutter/material.dart';
import 'package:flutter_goapi_chat_app/services/auth/auth_service.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final _auth = AuthService(); // или через provider/get_it

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await _auth.getValidAccessToken();

    if (token != null) {
      // токен есть — пользователь авторизован
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // нет токена — отправляем на логин
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
