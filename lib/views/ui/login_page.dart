import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay_nutritionist/models/doctor.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_text_fields.dart';
import 'package:nutri_gabay_nutritionist/views/ui/signup_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onSignIn;
  final BaseAuth auth;
  const LoginPage({super.key, this.onSignIn, required this.auth});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isObscure = true;
  String loginMsg = '';

  String regEx =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  late Doctor doctor;

  void validation() async {
    String userUID;
    loginMsg = '';
    if (_formKey.currentState!.validate()) {
      final collection = FirebaseFirestore.instance.collection('doctor');

      collection
          .where('email', isEqualTo: _email.text)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.size > 0) {
          final collection = FirebaseFirestore.instance
              .collection('doctor')
              .where('email', isEqualTo: _email.text)
              .withConverter(
                fromFirestore: Doctor.fromFirestore,
                toFirestore: (Doctor dt, _) => dt.toFirestore(),
              );

          await collection.get().then(
            (querySnapshot) async {
              for (var docSnapshot in querySnapshot.docs) {
                doctor = docSnapshot.data();

                if (doctor.status != 'Pending') {
                  try {
                    userUID = await widget.auth.signInWithEmailAndPassword(
                        doctor.email, _password.text);
                    // ignore: unnecessary_null_comparison
                    if (userUID != null) {
                      updateUserStatus(userUID);
                      widget.onSignIn!();
                    }
                  } on FirebaseAuthException {
                    loginMsg = 'Incorrect username or password';
                  }
                } else {
                  loginMsg = doctor.password == _password.text
                      ? 'Registration is pending for approval'
                      : 'Incorrect username or password';
                }
              }

              setState(() {});
            },
          );
        } else {
          loginMsg = 'Incorrect username or password';
        }
        setState(() {});
      });
    }
  }

  Future<void> updateUserStatus(String userUID) async {
    await FirebaseFirestore.instance.collection('doctor').doc(userUID).update({
      "isOnline": true,
      "lastActive": DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenSize.height * 0.15,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
                        height: 60,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/logo-name.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome Nutritionist',
                        style: appstyle(
                          20,
                          Colors.black,
                          FontWeight.w800,
                        ).copyWith(
                          shadows: const <Shadow>[
                            Shadow(
                              offset: Offset(-1, 10),
                              blurRadius: 3.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 400,
                    child: Text(
                      "Email",
                      style: appstyle(
                        12,
                        Colors.black,
                        FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 400,
                    child: UserCredentialTextField(
                      controller: _email,
                      label: "",
                      isObscure: false,
                      keyboardType: TextInputType.emailAddress,
                      validation: (value) {
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: screenSize.width < 500 ? 300 : 400,
                    child: Text(
                      "Password",
                      style: appstyle(
                        12,
                        Colors.black,
                        FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: screenSize.width < 500 ? 300 : 400,
                    child: UserCredentialTextField(
                      controller: _password,
                      label: "",
                      isObscure: isObscure,
                      keyboardType: TextInputType.text,
                      validation: (value) {
                        return null;
                      },
                      icon: isObscure
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      onTap: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    loginMsg,
                    style: appstyle(
                      11,
                      Colors.red,
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: UserCredentialPrimaryButton(
                      onPress: () {
                        validation();
                      },
                      label: "Login",
                      labelSize: 15,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: appstyle(14, Colors.black, FontWeight.w500),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Create your account",
                          style: appstyle(
                              14,
                              const Color.fromARGB(255, 28, 117, 190),
                              FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
