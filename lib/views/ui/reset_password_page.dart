import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_text_fields.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool isShowCurrent = false;
  bool isShowNew = false;
  bool isShowConfirm = false;
  bool isCurrentPasswordCorrect = true;

  Future<void> validateCurrentPassword() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    isCurrentPasswordCorrect = false;
    if (firebaseUser != null) {
      var authCredential = EmailAuthProvider.credential(
        email: firebaseUser.email.toString(),
        password: _currentController.text,
      );
      try {
        var authResult =
            await firebaseUser.reauthenticateWithCredential(authCredential);
        isCurrentPasswordCorrect = authResult.user != null;
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  Future<void> changePassword() async {
    await validateCurrentPassword().whenComplete(() {
      setState(() {});
    });

    if (_formKey.currentState!.validate()) {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.updatePassword(_newController.text);

        // final docUser = FirebaseFirestore.instance
        //     .collection('patient')
        //     .doc(firebaseUser.uid);
        // await docUser.update({"password": _newController.text});

        _currentController.clear();
        _newController.clear();
        _confirmController.clear();

        final snackBar = SnackBar(
          content: Text(
            'Password has been changed',
            style: appstyle(12, Colors.white, FontWeight.normal),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
                decoration: BoxDecoration(border: Border.all(width: 0.2))),
          ),
          toolbarHeight: 50,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Reset Password',
            style: appstyle(18, Colors.black, FontWeight.bold),
          ),
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.save_as_outlined,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Row(
            children: [
              screenSize.width > 800
                  ? Expanded(child: Container())
                  : const SizedBox(width: 10),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          UserCredentialTextField(
                            controller: _currentController,
                            // screenSize: screenSize,
                            label: "Current Password",
                            isObscure: !isShowCurrent,
                            keyboardType: TextInputType.emailAddress,
                            validation: (value) {
                              if (!isCurrentPasswordCorrect) {
                                return 'Password is incorrect';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                isShowCurrent = !isShowCurrent;
                                setState(() {});
                              },
                              icon: Icon(
                                isShowCurrent
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          UserCredentialTextField(
                            controller: _newController,
                            // screenSize: screenSize,
                            label: "New Password",
                            isObscure: !isShowNew,
                            keyboardType: TextInputType.text,
                            validation: (value) {
                              if (value == '') {
                                return 'New Password is required';
                              }
                              if (value!.length < 8) {
                                return 'Password must contain atleast 8 characters';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                isShowNew = !isShowNew;
                                setState(() {});
                              },
                              icon: Icon(
                                isShowNew
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          UserCredentialTextField(
                            controller: _confirmController,
                            // screenSize: screenSize,
                            label: "Confirm New Password",
                            isObscure: !isShowConfirm,
                            keyboardType: TextInputType.text,
                            validation: (value) {
                              if (value == '') {
                                return 'Confirm Password is required';
                              }
                              if (value != _newController.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              onPressed: () {
                                isShowConfirm = !isShowConfirm;
                                setState(() {});
                              },
                              icon: Icon(
                                isShowConfirm
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 90),
                            height: 35,
                            child: UserCredentialPrimaryButton(
                              onPress: () async {
                                await changePassword();
                              },
                              label: 'Change Password',
                              labelSize: 13,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              screenSize.width > 800
                  ? Expanded(child: Container())
                  : const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
