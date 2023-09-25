import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';

class MainPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  const MainPage({super.key, required this.auth, required this.onSignOut});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
