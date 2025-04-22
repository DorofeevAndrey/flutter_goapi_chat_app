import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.onTap});

  final void Function() onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? emailErrorText;
  String? passwordValidErrorText;
  String? passwordErrorText;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pwController = TextEditingController();

  final TextEditingController _confirmPwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _pwController.addListener(_validatePasswords);
    _confirmPwController.addListener(_validatePasswords);
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
    final confirmPw = _confirmPwController.text;

    setState(() {
      // Проверка длины
      if (pw.isNotEmpty && pw.length < 6) {
        passwordErrorText = 'Слишком короткий пароль (мин. 6 символов)';
      } else {
        passwordErrorText = null;
      }

      // Проверка совпадения паролей (только если оба поля заполнены)
      if (pw.isNotEmpty && confirmPw.isNotEmpty && pw != confirmPw) {
        passwordValidErrorText = 'Пароли не совпадают';
      } else {
        passwordValidErrorText = null;
      }
    });
  }

  //register method
  void register(BuildContext context) {
    // get auth service
    final auth = AuthService();
    // passwords match -> create user

    try {
      auth.register(_emailController.text, _pwController.text);
      auth.login(_emailController.text, _pwController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
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
              "Let's create an account for you",
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

            // confirm pw textfield
            MyTextfield(
              errorText: passwordValidErrorText,
              hintText: "Confirm password",
              obscureText: true,
              controller: _confirmPwController,
            ),
            const SizedBox(height: 25),

            // login button
            MyButton(
              isDisable:
                  emailErrorText != null ||
                  passwordValidErrorText != null ||
                  passwordErrorText != null,
              title: "Register",

              onTap: () {
                register(context);
              },
            ),
            const SizedBox(height: 25),

            // regiter now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Login now",
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
