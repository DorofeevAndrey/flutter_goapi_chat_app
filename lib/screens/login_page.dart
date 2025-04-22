import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function() onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? emailErrorText;
  String? passwordErrorText;

  //email and pw text controllers
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _pwController.addListener(_validatePasswords);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      if (email.isEmpty) {
        emailErrorText = null;
      } else if (!isValidEmail(email)) {
        emailErrorText = 'Некорректный email';
      } else {
        emailErrorText = null;
      }
    });
  }

  void _validatePasswords() {
    final pw = _pwController.text;

    setState(() {
      // Проверка длины
      if (pw.isNotEmpty && pw.length < 6) {
        passwordErrorText = 'Слишком короткий пароль (мин. 6 символов)';
      } else {
        passwordErrorText = null;
      }
    });
  }

  // login
  void login(context) async {
    // auth servicve
    final authService = AuthService();

    try {
      await authService.login(_emailController.text, _pwController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                "Неккоректное имя пользователя или пароль",
                // style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(Icons.message, size: 60, color: theme.colorScheme.primary),
            const SizedBox(height: 50),

            // welcome back message
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(color: theme.colorScheme.primary, fontSize: 16),
            ),
            const SizedBox(height: 25),

            // email textfield
            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
              errorText: emailErrorText,
            ),
            const SizedBox(height: 10),

            // pw textfield
            MyTextfield(
              errorText: passwordErrorText,
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),
            const SizedBox(height: 10),

            // login button
            MyButton(
              isDisable: emailErrorText != null || passwordErrorText != null,
              title: "Login",

              onTap: () {
                login(context);
              },
            ),
            const SizedBox(height: 25),

            // regiter now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not remember? ",
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
