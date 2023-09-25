import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onSignIn;
  final BaseAuth auth;
  const LoginPage({super.key, this.onSignIn, required this.auth});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
