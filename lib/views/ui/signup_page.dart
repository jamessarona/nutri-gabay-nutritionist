import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay_nutritionist/models/doctor.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_text_fields.dart';
import 'package:nutri_gabay_nutritionist/views/ui/pending_account_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _birthdate = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool isObscurePass = true;
  bool isObscureConfirmPass = true;
  bool isEmailExist = false;
  bool isLoading = false;
  String regEx =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  File? image;
  Uint8List webImage = Uint8List(8);
  Uint8List webPdfFile = Uint8List(8);
  String? webPdfFileName;

  Future<bool> register() async {
    if (RegExp(regEx).hasMatch(_email.text)) {
      isEmailExist = await hasExistingAccount();
    }
    if (_formKey.currentState!.validate()) {
      bool result = false;
      // String userUID = await FireBaseAuth()
      //     .signUpWithEmailAndPassword(_email.text, _password.text);
      // if (userUID != '') {
      await createNutritionist().whenComplete(() {
        result = true;
      });
      return result;
      // }
    }
    return false;
  }

  Future<bool> hasExistingAccount() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (_email.text.isEmpty) {
      return false;
    }
    bool result = true;
    await firebaseAuth
        .fetchSignInMethodsForEmail(_email.text)
        .then((signInMethods) => result = signInMethods.isNotEmpty);

    return result;
  }

  Future<void> createNutritionist() async {
    final docUser = FirebaseFirestore.instance.collection('doctor').doc();

    Doctor user = Doctor(
      uid: docUser.id,
      name: _name.text,
      email: _email.text,
      phone: _phone.text,
      birthdate: _birthdate.text,
      address: _address.text,
      specialization: "Nutritionist",
      image:
          'https://firebasestorage.googleapis.com/v0/b/nutri-gabay.appspot.com/o/images%2Fprofiles%2Fdefault%2Fdefault.png?alt=media&token=fce52102-d785-4883-ae5a-f7d26fa502ce',
      file: '',
      about: '',
      specialties: '',
      status: 'Pending',
      password: _password.text,
      isOnline: true,
      lastActive: DateTime.now(),
    );

    final json = user.toJson();
    await docUser.set(json).whenComplete(() {
      _name.clear();
      _email.clear();
      _phone.clear();
      _address.clear();
      _birthdate.clear();
      _password.clear();
      _confirmPassword.clear();
    });
    if (image != null) {
      await uploadImage(user.uid).whenComplete(() {
        image = null;
        webImage = Uint8List(8);
      });
    }
    if (webPdfFileName != null) {
      await uploadPdfFile(user.uid).whenComplete(() {
        webPdfFileName = null;
        webPdfFile = Uint8List(8);
      });
    }
    setState(() {});
  }

  Future<void> uploadImage(String uid) async {
    try {
      var snapshot = await FirebaseStorage.instance
          .ref('images/profiles/doctors/$uid')
          .putData(
            webImage,
            SettableMetadata(contentType: 'image/jpeg'),
          );

      var downloadUrl = await snapshot.ref.getDownloadURL();

      saveImageToDatabase(uid, downloadUrl, "image");
      // ignore: empty_catches
    } on FirebaseException {}
  }

  Future<void> uploadPdfFile(String uid) async {
    try {
      var snapshot =
          await FirebaseStorage.instance.ref('files/doctors/$uid.pdf').putData(
                webPdfFile,
                SettableMetadata(contentType: 'application/pdf'),
              );

      var downloadUrl = await snapshot.ref.getDownloadURL();

      saveImageToDatabase(uid, downloadUrl, "file");
      // ignore: empty_catches
    } on FirebaseException {}
  }

  Future<void> saveImageToDatabase(String uid, String url, String field) async {
    try {
      final collection = FirebaseFirestore.instance.collection('doctor');

      await collection.doc(uid).update({field: url});
      // ignore: empty_catches
    } on FirebaseException {}
  }

  Future pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          final pickedImage = File(image.path);
          this.image = pickedImage;
        });
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          final pickedImage = File(image.path);
          this.image = pickedImage;
        });
      }
    }
  }

  Future pickPdfFile() async {
    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false);

      if (result != null) {
        setState(() {
          webPdfFileName = null;
          webPdfFile = result.files.first.bytes!;
          webPdfFileName = result.files.first.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.grey.shade100,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 20),
                      height: 60,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo-name.png"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 18, left: 20, right: 20, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Detail',
                            style: appstyle(18, Colors.black, FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                color: Colors.grey.shade300,
                                child: image == null
                                    ? IconButton(
                                        onPressed: () {
                                          pickImage();
                                        },
                                        icon: const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 35,
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          pickImage();
                                        },
                                        child: kIsWeb
                                            ? Image.memory(
                                                webImage,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.network(
                                                image!.path,
                                                fit: BoxFit.fill,
                                              )),
                              ),
                            ),
                          ),
                          Container(
                            height: 90,
                            width: screenSize.width * 0.4,
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              splashColor: customColor,
                              onTap: () {
                                pickPdfFile();
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.fileCirclePlus,
                                    color: Colors.black54,
                                    size: 25,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    webPdfFileName ?? 'Attach file',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25, left: 15, right: 15),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: screenSize.width * 0.45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nutritionist Name',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: 75,
                                    child: RegistrationTextField(
                                      controller: _name,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.emailAddress,
                                      maxLines: 1,
                                      validation: (value) {
                                        if (value == '') {
                                          return 'Please enter a name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Email Address',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: 75,
                                    child: RegistrationTextField(
                                      controller: _email,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.emailAddress,
                                      maxLines: 1,
                                      validation: (value) {
                                        if (value == '') {
                                          return 'Please enter an email';
                                        } else if (!RegExp(regEx)
                                            .hasMatch(value!)) {
                                          return 'Invalid email format';
                                        } else if (isEmailExist) {
                                          return 'Email is already in used';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Phone Number',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 75,
                                    child: RegistrationTextField(
                                      controller: _phone,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      validation: (value) {
                                        return null;
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Address',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: 200,
                                    child: RegistrationTextField(
                                      controller: _address,
                                      label: '',
                                      isObscure: false,
                                      keyboardType: TextInputType.text,
                                      maxLines: 4,
                                      validation: (value) {
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenSize.width * 0.45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date of Birth',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: 75,
                                    child: TextFormField(
                                      controller: _birthdate,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: customColor),
                                        ),
                                        fillColor: Colors.white70,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10.0),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                                  primary: customColor,
                                                  onPrimary: Colors.white,
                                                  onSurface: Colors.black,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );

                                        if (pickedDate != null) {
                                          String formattedDate =
                                              DateFormat('MM/dd/yyyy')
                                                  .format(pickedDate);

                                          setState(() {
                                            _birthdate.text = formattedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Password',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: 75,
                                    child: RegistrationTextField(
                                      controller: _password,
                                      label: '',
                                      isObscure: isObscurePass,
                                      keyboardType: TextInputType.emailAddress,
                                      maxLines: 1,
                                      validation: (value) {
                                        if (value == '') {
                                          return 'Please enter a password';
                                        } else if (value!.length < 8) {
                                          return 'Password must be more than 8 characters';
                                        }

                                        return null;
                                      },
                                      icon: isObscurePass
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      onTap: () {
                                        setState(() {
                                          isObscurePass = !isObscurePass;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Confirm Password',
                                    style: appstyle(
                                        15, Colors.black, FontWeight.w500),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    height: 75,
                                    child: RegistrationTextField(
                                      controller: _confirmPassword,
                                      label: '',
                                      isObscure: isObscureConfirmPass,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      validation: (value) {
                                        if (value == '') {
                                          return 'Please confirm the password';
                                        } else if (_password.text != value) {
                                          return 'Password does not match';
                                        }

                                        return null;
                                      },
                                      icon: isObscureConfirmPass
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      onTap: () {
                                        setState(() {
                                          isObscureConfirmPass =
                                              !isObscureConfirmPass;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 200,
                                    height: 40,
                                    child: UserCredentialPrimaryButton(
                                      onPress: () async {
                                        if (!isLoading) {
                                          isEmailExist = false;
                                          isLoading = true;
                                          if (await register()) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const PendingAccountPage(),
                                              ),
                                            );
                                          }
                                          isLoading = false;
                                        }
                                      },
                                      label: "Make Account",
                                      labelSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
