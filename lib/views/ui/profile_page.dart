import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay_nutritionist/models/appointment.dart';
import 'package:nutri_gabay_nutritionist/models/doctor.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_text_fields.dart';
import 'package:nutri_gabay_nutritionist/views/ui/appointment_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _specialization = TextEditingController();
  final TextEditingController _aboutMe = TextEditingController();
  final TextEditingController _specialties = TextEditingController();
  final CalendarController _calendarController = CalendarController();

  bool isEditable = false;
  int tabIndex = 0;
  Doctor? doctor;

  File? image;
  Uint8List webImage = Uint8List(8);

  List<QueryDocumentSnapshot<Appointments>>? appointments;

  void getDoctorInfo() async {
    String uid = await FireBaseAuth().currentUser();
    final ref =
        FirebaseFirestore.instance.collection("doctor").doc(uid).withConverter(
              fromFirestore: Doctor.fromFirestore,
              toFirestore: (Doctor patient, _) => patient.toFirestore(),
            );
    final docSnap = await ref.get();
    doctor = docSnap.data()!;
    _name.text = doctor!.name;
    _specialization.text = doctor!.specialization;
    _aboutMe.text = doctor!.about;
    _specialties.text = doctor!.specialties;
    isEditable = false;
    getApprovedAppointments();
    setState(() {});
  }

  void saveChanges() async {
    String uid = await FireBaseAuth().currentUser();
    final collection = FirebaseFirestore.instance.collection('doctor');

    await collection.doc(uid).update({
      "name": _name.text,
      "specialization": _specialization.text,
      "about": _aboutMe.text,
      "specialties": _specialties.text,
    }).whenComplete(() {
      getDoctorInfo();
    });
    if (image != null) {
      await uploadImage(uid).whenComplete(() {
        image = null;
        webImage = Uint8List(8);
        setState(() {});
        getDoctorInfo();
      });
    }
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
        webImage = f;
        final pickedImage = File(image.path);
        this.image = pickedImage;
        setState(() {});
      }
    }
  }

  List<Appointment> getAppointments() {
    getApprovedAppointments();
    List<Appointment> meetings = <Appointment>[];

    if (appointments != null) {
      for (var appointment in appointments!) {
        final DateTime bookingStart = DateFormat("MM/dd/yyyy hh").parse(
            "${appointment.data().dateSchedule} ${appointment.data().hourStart.toStringAsFixed(2)}");
        final DateTime bookingEnd = DateFormat("MM/dd/yyyy hh").parse(
            "${appointment.data().dateSchedule} ${appointment.data().hourEnd.toStringAsFixed(2)}");
        meetings.add(
          Appointment(
              startTime: bookingStart,
              endTime: bookingEnd,
              subject: appointment.data().notes,
              color: customColor),
        );
      }
    }
    return meetings;
  }

  Future<void> getApprovedAppointments() async {
    if (doctor != null) {
      final docRef = FirebaseFirestore.instance
          .collection("appointment")
          .where(
            Filter.and(Filter("status", isNotEqualTo: "Pending"),
                Filter("doctorId", isEqualTo: doctor!.uid)),
          )
          .withConverter(
            fromFirestore: Appointments.fromFirestore,
            toFirestore: (Appointments ptn, _) => ptn.toFirestore(),
          );
      await docRef.get().then(
        (querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            appointments = querySnapshot.docs;
          }
        },
      );
    }
  }

  @override
  void initState() {
    getDoctorInfo();
    super.initState();
  }

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
              child: doctor == null
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.01),
                            height: 180,
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: screenSize.width * 0.005,
                                  right: screenSize.width * 0.005,
                                  top: screenSize.width * 0.005,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 120,
                                          width: 120,
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.grey.shade300,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              color: Colors.grey.shade300,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (isEditable) {
                                                    pickImage();
                                                  }
                                                },
                                                child: image != null
                                                    ? Image.memory(
                                                        webImage,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : doctor!.image == ''
                                                        ? const Icon(Icons
                                                            .person_outlined)
                                                        : Image.network(
                                                            doctor!.image,
                                                            fit: BoxFit.fill,
                                                          ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          height: 120,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              !isEditable
                                                  ? Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '${_name.text}\n',
                                                            style: appstyle(
                                                                18,
                                                                Colors.black,
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                _specialization
                                                                    .text,
                                                            style: appstyle(
                                                                13,
                                                                Colors.grey,
                                                                FontWeight
                                                                    .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height: 50,
                                                      width: 200,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                TextFormField(
                                                              controller: _name,
                                                              style: appstyle(
                                                                  18,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .bold),
                                                              cursorColor:
                                                                  customColor,
                                                              decoration:
                                                                  const InputDecoration(
                                                                enabledBorder:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              customColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          SizedBox(
                                                            height: 20,
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _specialization,
                                                              style: appstyle(
                                                                  18,
                                                                  Colors.grey,
                                                                  FontWeight
                                                                      .normal),
                                                              cursorColor:
                                                                  customColor,
                                                              decoration:
                                                                  const InputDecoration(
                                                                enabledBorder:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              customColor),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                              SizedBox(
                                                height: 23,
                                                width: 100,
                                                child:
                                                    UserCredentialPrimaryButton(
                                                        onPress: () {
                                                          if (isEditable) {
                                                            saveChanges();
                                                          }
                                                          setState(() {
                                                            isEditable =
                                                                !isEditable;
                                                          });
                                                        },
                                                        label: !isEditable
                                                            ? 'Edit'
                                                            : 'Save',
                                                        labelSize: 11),
                                              ),
                                            ],
                                          ),
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
                                              style: appstyle(13, Colors.black,
                                                  FontWeight.w700),
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
                                              style: appstyle(13, Colors.black,
                                                  FontWeight.w700),
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
                          tabIndex == 0
                              ? Container(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenSize.width * 0.01),
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenSize.height * 0.01),
                                  width: double.infinity,
                                  height: 500,
                                  child: Card(
                                    child: SfCalendar(
                                      controller: _calendarController,
                                      headerStyle: const CalendarHeaderStyle(
                                          textAlign: TextAlign.center),
                                      view: CalendarView.month,
                                      dataSource: AppointmentSchedules(
                                          getAppointments()),
                                      monthViewSettings:
                                          const MonthViewSettings(
                                        appointmentDisplayMode:
                                            MonthAppointmentDisplayMode
                                                .indicator,
                                        showAgenda: true,
                                        appointmentDisplayCount: 5,
                                      ),
                                      initialSelectedDate: DateTime.now(),
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
