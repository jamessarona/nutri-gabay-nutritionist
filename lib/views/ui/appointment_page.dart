import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/models/doctor.dart';
import 'package:nutri_gabay_nutritionist/models/patient.dart';
import 'package:nutri_gabay_nutritionist/models/patient_nutrition.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  late Size screenSize;
  String uid = '';
  List<QueryDocumentSnapshot<Patient>>? patients;
  List<QueryDocumentSnapshot<PatientNutrition>>? patientNutritions;
  List<QueryDocumentSnapshot<Doctor>>? doctors;

  Future<void> getNutritionistId() async {
    uid = await FireBaseAuth().currentUser();
    setState(() {});
  }

  Future<void> getPatients() async {
    final docRef =
        FirebaseFirestore.instance.collection("patient").withConverter(
              fromFirestore: Patient.fromFirestore,
              toFirestore: (Patient pt, _) => pt.toFirestore(),
            );
    await docRef.get().then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          patients = querySnapshot.docs;
          setState(() {});
        }
      },
    );
  }

  Future<void> getPatientNutritions() async {
    final docRef = FirebaseFirestore.instance
        .collection("patient_nutritional_profile")
        .withConverter(
          fromFirestore: PatientNutrition.fromFirestore,
          toFirestore: (PatientNutrition ptn, _) => ptn.toFirestore(),
        );
    await docRef.get().then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          patientNutritions = querySnapshot.docs;
          setState(() {});
        }
      },
    );
  }

  String getPatientInfoByField(String patientId, String field) {
    String result = '';
    if (patients != null) {
      for (var patient in patients!) {
        if (patientId == patient.data().uid) {
          if (field == 'name') {
            result = "${patient.data().firstname} ${patient.data().lastname}";
          } else if (field == 'firstname') {
            result = patient.data().firstname;
          } else if (field == 'lastname') {
            result = patient.data().lastname;
          } else if (field == 'email') {
            result = patient.data().email;
          } else if (field == 'image') {
            result = patient.data().image;
          } else if (field == 'phone') {
            result = patient.data().phone;
          }
          break;
        }
      }
    }
    return result;
  }

  String getScheduleRange(int hourStart, int hourEnd) {
    String result = '';

    if (hourStart > 12) {
      result = '${hourStart - 12} - ${hourEnd - 12} PM';
    } else if (hourEnd < 13) {
      result = '$hourStart - $hourEnd AM';
    } else {
      result = '$hourStart AM - $hourEnd PM';
    }
    return result;
  }

  Widget buildAppointmentRequest() {
    return Container(
      height: 800,
      width: screenSize.width > 500 ? screenSize.width * 0.4 : double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      // ignore: unnecessary_null_comparison
      child: uid != ''
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointment')
                  .where(
                    Filter.and(Filter("status", isEqualTo: "Pending"),
                        Filter("doctorId", isEqualTo: uid)),
                  )
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Text('No Records');
                }
                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return Container(
                            padding: const EdgeInsets.only(
                                top: 5, left: 5, right: 5),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 0.4,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Container(
                                          color: Colors.grey.shade300,
                                          child: Image.network(
                                            getPatientInfoByField(
                                                data['patientId'], 'image'),
                                            fit: BoxFit.fitHeight,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                  color: Colors.grey.shade200);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          RichText(
                                            maxLines: 2,
                                            text: TextSpan(
                                              text: getPatientInfoByField(
                                                  data['patientId'], 'name'),
                                              style: appstyle(15, Colors.black,
                                                  FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      ' request you appointment in ${data['dateSchedule']}',
                                                  style: appstyle(
                                                      14,
                                                      Colors.black,
                                                      FontWeight.normal),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' at ${getScheduleRange(data['hourStart'], data['hourEnd'])}',
                                                  style: appstyle(
                                                      14,
                                                      Colors.black,
                                                      FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                //TODO
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 70,
                                    ),
                                    // RichText(
                                    //           maxLines: 1,
                                    //           text: TextSpan(
                                    //             text: getPatientNutritionInfoByField(
                                    //                 data['patientId'], 'name'),
                                    //             style: appstyle(15, Colors.black,
                                    //                 FontWeight.bold),
                                    //             children: <TextSpan>[
                                    //               TextSpan(
                                    //                 text:
                                    //                     ' request you appointment in ${data['dateSchedule']}',
                                    //                 style: appstyle(
                                    //                     14,
                                    //                     Colors.black,
                                    //                     FontWeight.normal),
                                    //               ),
                                    //               TextSpan(
                                    //                 text:
                                    //                     ' at ${getScheduleRange(data['hourStart'], data['hourEnd'])}',
                                    //                 style: appstyle(
                                    //                     14,
                                    //                     Colors.black,
                                    //                     FontWeight.normal),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                  ],
                                )
                              ],
                            ));
                      })
                      .toList()
                      .cast(),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildSchedules() {
    return Container(
      width: screenSize.width > 500 ? screenSize.width * 0.4 : double.infinity,
    );
  }

  @override
  void initState() {
    getNutritionistId();
    getPatients();
    getPatientNutritions();
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
              'Appointment Request',
              style: appstyle(
                25,
                Colors.black,
                FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: screenSize.width > 500
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildAppointmentRequest(),
                      buildSchedules(),
                    ],
                  )
                : ListView(
                    children: [
                      buildAppointmentRequest(),
                      buildSchedules(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
