import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_text_fields.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _aboutMe = TextEditingController();
  final TextEditingController _specialties = TextEditingController();

  bool isEditable = false;
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: 50,
              width: double.infinity,
              color: customColor[70],
              alignment: Alignment.centerLeft,
              child: Text(
                'My Profile',
                style: appstyle(
                  25,
                  Colors.black,
                  FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.01),
                      height: 150,
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenSize.width * 0.005,
                            right: screenSize.width * 0.005,
                            top: screenSize.width * 0.005,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        color: Colors.grey.shade300,
                                        child: GestureDetector(
                                          onTap: () {},
                                          child:
                                              const Icon(Icons.person_outlined),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'James Angelo C. Sarona\n',
                                              style: appstyle(18, Colors.black,
                                                  FontWeight.bold),
                                            ),
                                            TextSpan(
                                              text: 'Nutrisionist',
                                              style: appstyle(13, Colors.grey,
                                                  FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      SizedBox(
                                        height: 23,
                                        width: 100,
                                        child: UserCredentialPrimaryButton(
                                            onPress: () {
                                              if (isEditable) {
                                                //saving changes
                                              }
                                              setState(() {
                                                isEditable = !isEditable;
                                              });
                                            },
                                            label: !isEditable
                                                ? 'Edit Profile'
                                                : 'Save',
                                            labelSize: 11),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        tabIndex = 0;
                                      });
                                    },
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: tabIndex == 0
                                                ? customColor
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'About',
                                        style: appstyle(
                                            13, Colors.black, FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        tabIndex = 1;
                                      });
                                    },
                                    child: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: tabIndex != 0
                                                ? customColor
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Schedules',
                                        style: appstyle(
                                            13, Colors.black, FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.01),
                      height: 500,
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenSize.width * 0.005,
                            right: screenSize.width * 0.005,
                            top: screenSize.width * 0.005,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ProfileTextField(
                                controller: _aboutMe,
                                label: 'About Me',
                                isObscure: false,
                                keyboardType: TextInputType.text,
                                maxLines: 11,
                                isEditable: isEditable,
                              ),
                              const SizedBox(height: 20),
                              ProfileTextField(
                                controller: _specialties,
                                label: 'Specialties',
                                isObscure: false,
                                keyboardType: TextInputType.text,
                                maxLines: 11,
                                isEditable: isEditable,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
