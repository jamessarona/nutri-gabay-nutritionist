import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';
import 'package:nutri_gabay_nutritionist/views/ui/login_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/main_page.dart';

class Root extends StatefulWidget {
  final BaseAuth auth;
  const Root({
    super.key,
    required this.auth,
  });
  @override
  // ignore: library_private_types_in_public_api
  _RootState createState() => _RootState();
}

enum AuthSatus { notSignedIn, signedIn }

class _RootState extends State<Root> {
  AuthSatus _authSatus = AuthSatus.notSignedIn;

  //check the current status of the user on start of the app
  //called before statefull widget
  @override
  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authSatus = userId == '' ? AuthSatus.notSignedIn : AuthSatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authSatus = AuthSatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authSatus = AuthSatus.notSignedIn;
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (_authSatus) {
      case AuthSatus.notSignedIn:
        return LoginPage(
          auth: widget.auth,
          onSignIn: _signedIn,
        );
      case AuthSatus.signedIn:
        return MainPage(
          auth: widget.auth,
          onSignOut: _signedOut,
        );
    }
  }
}
