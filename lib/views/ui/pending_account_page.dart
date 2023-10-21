import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/root_page.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';

class PendingAccountPage extends StatefulWidget {
  const PendingAccountPage({super.key});

  @override
  State<PendingAccountPage> createState() => _PendingAccountPageState();
}

class _PendingAccountPageState extends State<PendingAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text(
              'Waiting for Appoval',
              style: appstyle(15, Colors.black, FontWeight.bold),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 130,
              child: UserCredentialPrimaryButton(
                  onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Root(
                          auth: FireBaseAuth(),
                        ),
                      ),
                    );
                  },
                  label: 'Return ',
                  labelSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
