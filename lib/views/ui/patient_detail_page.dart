import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/models/assessment.dart';
import 'package:nutri_gabay_nutritionist/models/diagnosis.dart';
import 'package:nutri_gabay_nutritionist/models/form.dart';
import 'package:nutri_gabay_nutritionist/models/message_controller.dart';
import 'package:nutri_gabay_nutritionist/models/patient.dart';
import 'package:nutri_gabay_nutritionist/models/patient_nutrition.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_container.dart';
import 'package:nutri_gabay_nutritionist/views/ui/chat_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/monitoring_evaluation_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/nutrition_assessment_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/nutrition_diagnosis_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/nutrition_intervention_page.dart';
// ignore: depend_on_referenced_packages
import 'package:badges/badges.dart' as badges;

class PatientDetailPage extends StatefulWidget {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String patientNutritionalId;

  const PatientDetailPage({
    super.key,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.patientNutritionalId,
  });

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  late Size screenSize;

  Patient? patient;
  PatientNutrition? patientNutrition;

  int chatCount = 0;
  int assessmentCount = 0;
  int diagnosisCount = 0;
  int interventionCount = 0;
  int monitoringCount = 0;

  void getPatientInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("patient")
        .doc(widget.patientId)
        .withConverter(
          fromFirestore: Patient.fromFirestore,
          toFirestore: (Patient pt, _) => pt.toFirestore(),
        );
    final docSnap = await ref.get();
    patient = docSnap.data()!;
    setState(() {});
  }

  void getPatientNutritionInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("patient_nutritional_profile")
        .doc(widget.patientNutritionalId)
        .withConverter(
          fromFirestore: PatientNutrition.fromFirestore,
          toFirestore: (PatientNutrition ptn, _) => ptn.toFirestore(),
        );
    final docSnap = await ref.get();
    patientNutrition = docSnap.data()!;
    setState(() {});
  }

  List<Widget> buildBmiInfo() {
    return [
      Text(
        'BMI and measurements',
        style: appstyle(18, Colors.black, FontWeight.bold)
            .copyWith(color: customColor[10]),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          Text(
            'Height: ${patientNutrition!.height.toStringAsFixed(2)} cm',
            style: appstyle(13, Colors.black, FontWeight.bold),
          ),
          const SizedBox(width: 30),
          Text(
            'BMI: ${patientNutrition!.bmi.toStringAsFixed(2)}',
            style: appstyle(13, Colors.black, FontWeight.bold),
          ),
        ],
      ),
      Text(
        'Weight: ${patientNutrition!.weight.toStringAsFixed(2)} kg',
        style: appstyle(13, Colors.black, FontWeight.bold),
      ),
    ];
  }

  List<Widget> buildMnaInfo() {
    return [
      Text(
        'Mini-Nutritional Assesment - Result',
        style: appstyle(18, Colors.black, FontWeight.bold)
            .copyWith(color: customColor[10]),
      ),
      const SizedBox(height: 5),
      Text(
        'Weight: ${patientNutrition!.points.toStringAsFixed(0)} (${patientNutrition!.result})',
        style: appstyle(
          13,
          Colors.black,
          FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.visible,
      ),
    ];
  }

  List<Widget> buildNutritionStatus() {
    return [
      Text(
        'Nutritional Status',
        style: appstyle(18, Colors.black, FontWeight.bold)
            .copyWith(color: customColor[10]),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 100,
            child: Image.asset(
              'assets/icons/${patientNutrition!.status.toLowerCase()}.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          Text(
            patientNutrition!.status,
            style: appstyle(18, Colors.black, FontWeight.bold),
          )
        ],
      ),
    ];
  }

  List<Widget> buildActions() {
    return [
      Column(
        children: [
          Row(
            children: [
              badges.Badge(
                badgeContent: Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    assessmentCount > 9 ? "9+" : assessmentCount.toString(),
                    style: appstyle(20, Colors.black, FontWeight.bold),
                  ),
                ),
                badgeStyle: const badges.BadgeStyle(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                showBadge: assessmentCount > 0,
                position: badges.BadgePosition.topEnd(top: -3, end: 0),
                child: PatientActionsContainer(
                  title: 'Nutrition Assessment',
                  icon: 'nutrition-assessment',
                  iconData: Icons.phone,
                  color: const Color.fromARGB(255, 253, 195, 10),
                  isSmall: true,
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (ctx) => NutritionAssessmentPage(
                          appointmentId: widget.appointmentId,
                          doctorId: widget.doctorId,
                          patientId: widget.patientId,
                          patientNutritionalId: widget.patientNutritionalId,
                        ),
                      ),
                    )
                        .whenComplete(() async {
                      await getUpdates();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              badges.Badge(
                badgeContent: Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    diagnosisCount == 0 ? "!" : "",
                    style: appstyle(25, Colors.black, FontWeight.bold),
                  ),
                ),
                badgeStyle: const badges.BadgeStyle(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                showBadge: diagnosisCount == 0,
                position: badges.BadgePosition.topEnd(top: -3, end: 0),
                child: PatientActionsContainer(
                  title: 'Nutrition Diagnosis',
                  icon: 'diagnosis',
                  iconData: Icons.phone,
                  color: const Color.fromARGB(255, 253, 195, 10),
                  isSmall: true,
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (ctx) => NutritionDiagnosisPage(
                          appointmentId: widget.appointmentId,
                          doctorId: widget.doctorId,
                          patientId: widget.patientId,
                          patientNutritionalId: widget.patientNutritionalId,
                        ),
                      ),
                    )
                        .whenComplete(() async {
                      await getUpdates();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              badges.Badge(
                badgeContent: Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    interventionCount > 9 ? "9+" : interventionCount.toString(),
                    style: appstyle(20, Colors.black, FontWeight.bold),
                  ),
                ),
                badgeStyle: const badges.BadgeStyle(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                showBadge: interventionCount > 0,
                position: badges.BadgePosition.topEnd(top: -3, end: 0),
                child: PatientActionsContainer(
                  title: 'Nutrition\nIntervention',
                  icon: 'nutri-intervention',
                  iconData: Icons.phone,
                  color: customColor,
                  isSmall: true,
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (ctx) => NutritionInterventionPage(
                          appointmentId: widget.appointmentId,
                          patientNutritionalId: widget.patientNutritionalId,
                          doctorId: widget.doctorId,
                          patientId: widget.patientId,
                        ),
                      ),
                    )
                        .whenComplete(() async {
                      await getUpdates();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              badges.Badge(
                badgeContent: Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    monitoringCount > 9 ? "9+" : monitoringCount.toString(),
                    style: appstyle(20, Colors.black, FontWeight.bold),
                  ),
                ),
                badgeStyle: const badges.BadgeStyle(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                showBadge: monitoringCount > 0,
                position: badges.BadgePosition.topEnd(top: -3, end: 0),
                child: PatientActionsContainer(
                  title: 'Monitoring and \nEvaluation',
                  icon: 'monitoring-evaluation',
                  iconData: Icons.phone,
                  color: const Color.fromARGB(255, 252, 67, 66),
                  isSmall: true,
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (ctx) => MonitoringEvaluationPage(
                          appointmentId: widget.appointmentId,
                          doctorId: widget.doctorId,
                          patientId: widget.patientId,
                          patientNutritionalId: widget.patientNutritionalId,
                        ),
                      ),
                    )
                        .whenComplete(() async {
                      await getUpdates();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          Row(
            children: [
              badges.Badge(
                badgeContent: Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    chatCount > 9 ? "9+" : chatCount.toString(),
                    style: appstyle(20, Colors.black, FontWeight.bold),
                  ),
                ),
                badgeStyle: const badges.BadgeStyle(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                showBadge: chatCount > 0,
                position: badges.BadgePosition.topEnd(top: -3, end: 0),
                child: PatientActionsContainer(
                  title: 'Chat',
                  icon: 'chat',
                  iconData: Icons.phone,
                  color: const Color.fromARGB(255, 253, 195, 10),
                  isSmall: true,
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (ctx) => ChatPage(
                          doctorId: widget.doctorId,
                          patientId: widget.patientId,
                          appointmentId: widget.appointmentId,
                        ),
                      ),
                    )
                        .whenComplete(() async {
                      await getUpdates();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      )
    ];
  }

  Future<void> getNewChatCount() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('chat')
        .where(
          Filter.and(Filter("isSeen", isEqualTo: false),
              Filter("receiverId", isEqualTo: widget.doctorId)),
        )
        .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message msg, _) => msg.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        chatCount = querySnapshot.docs.length;
      },
    );
  }

  Future<void> getNewAssessmentCount() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('assessment')
        .where(
          "isSeen",
          isEqualTo: false,
        )
        .withConverter(
          fromFirestore: Assessment.fromFirestore,
          toFirestore: (Assessment assessment, _) => assessment.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        assessmentCount = querySnapshot.docs.length;
      },
    );
  }

  Future<void> getNewDiagnosisCount() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('diagnosis')
        .withConverter(
          fromFirestore: Diagnosis.fromFirestore,
          toFirestore: (Diagnosis diagnosis, _) => diagnosis.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        diagnosisCount = querySnapshot.docs.length;
      },
    );
  }

  Future<void> getNewInterventionCount() async {
    interventionCount = 0;
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files');

    await collection.get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await getNewInterventionCommentCount(docSnapshot.data()["id"]);
        }
      },
    );
  }

  Future<void> getNewInterventionCommentCount(String fileId) async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(fileId)
        .collection('comments')
        .where(
          Filter.and(Filter("isPatient", isEqualTo: true),
              Filter("isSeen", isEqualTo: false)),
        );

    await collection.get().then(
      (querySnapshot) {
        interventionCount += querySnapshot.docs.length;
      },
    );
  }

  Future<void> getNewMonitoringCount() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('form')
        .where(
          Filter.and(Filter("answered", isEqualTo: true),
              Filter("isSeen", isEqualTo: false)),
        )
        .withConverter(
          fromFirestore: FormQuestion.fromFirestore,
          toFirestore: (FormQuestion fq, _) => fq.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        monitoringCount = querySnapshot.docs.length;
      },
    );
  }

  Future<void> getUpdates() async {
    await getNewChatCount();
    await getNewAssessmentCount();
    await getNewDiagnosisCount();
    await getNewInterventionCount();
    await getNewMonitoringCount();

    setState(() {});
  }

  @override
  void initState() {
    getPatientInfo();
    getPatientNutritionInfo();

    // const oneSec = Duration(seconds: 1);
    // Timer.periodic(oneSec, (Timer t) =>
    getUpdates();
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "Patient",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          children: [
            // const SizedBox(height: 20),
            // Container(
            //   width: 150,
            //   alignment: AlignmentDirectional.centerEnd,
            //   margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
            //   child: CustomButton(
            //     onPress: () {},
            //     label: 'Download Patient Information',
            //     labelSize: 15,
            //     radius: 5,
            //   ),
            // ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
              constraints: BoxConstraints(minHeight: screenSize.height * 0.8),
              child: patient != null && patientNutrition != null
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  color: Colors.grey.shade200,
                                  child: patient!.image == ''
                                      ? const Icon(
                                          Icons.person,
                                          size: 30,
                                        )
                                      : Image.network(patient!.image,
                                          fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  '${patient!.firstname} ${patient!.lastname}',
                                  style: appstyle(
                                      18, Colors.black, FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                                Text(
                                  'Age: ${patientNutrition!.age} ${patientNutrition!.sex} ${patientNutrition!.birthdate != '' ? "(${patientNutrition!.birthdate})" : ''}',
                                  style: appstyle(
                                      13, Colors.black, FontWeight.normal),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                                Text(
                                  patient!.email,
                                  style: appstyle(
                                      13, Colors.black, FontWeight.normal),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                                Text(
                                  patient!.phone,
                                  style: appstyle(
                                      13, Colors.black, FontWeight.normal),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        screenSize.width > 500
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenSize.width > 500
                                        ? screenSize.width * .45
                                        : double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildBmiInfo(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenSize.width > 500
                                        ? screenSize.width * .45
                                        : double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildMnaInfo(),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenSize.width > 500
                                        ? screenSize.width * .45
                                        : double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildBmiInfo(),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    width: screenSize.width > 500
                                        ? screenSize.width * .45
                                        : double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildMnaInfo(),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 30),
                        screenSize.width > 500
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenSize.width > 500
                                        ? screenSize.width * .45
                                        : double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildNutritionStatus(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenSize.width > 500
                                        ? screenSize.width * .45
                                        : double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildActions(),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: screenSize.width > 500
                                        ? screenSize.width * .45
                                        : double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildNutritionStatus(),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    width: screenSize.width > 500
                                        ? screenSize.width * .45
                                        : double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildActions(),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
