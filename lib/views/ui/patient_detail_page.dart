import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/models/patient.dart';
import 'package:nutri_gabay_nutritionist/models/patient_nutrition.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_container.dart';
import 'package:nutri_gabay_nutritionist/views/ui/chat_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/monitoring_evaluation_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/nutrition_assessment_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/nutrition_diagnosis_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/nutrition_intervention_page.dart';

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
        'BMI and Recommended Caloric Intake',
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
              PatientActionsContainer(
                title: 'Nutrition Assessment',
                icon: 'nutrition-assessment',
                iconData: Icons.phone,
                color: const Color.fromARGB(255, 253, 195, 10),
                isSmall: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => NutritionAssessmentPage(
                        appointmentId: widget.appointmentId,
                        doctorId: widget.doctorId,
                        patientId: widget.patientId,
                        patientNutritionalId: widget.patientNutritionalId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              PatientActionsContainer(
                title: 'Nutrition Diagnosis',
                icon: 'diagnosis',
                iconData: Icons.phone,
                color: const Color.fromARGB(255, 253, 195, 10),
                isSmall: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => NutritionDiagnosisPage(
                        appointmentId: widget.appointmentId,
                        doctorId: widget.doctorId,
                        patientId: widget.patientId,
                        patientNutritionalId: widget.patientNutritionalId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              PatientActionsContainer(
                title: 'Nutrition\nIntervention',
                icon: 'nutri-intervention',
                iconData: Icons.phone,
                color: customColor,
                isSmall: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => NutritionInterventionPage(
                        appointmentId: widget.appointmentId,
                        patientNutritionalId: widget.patientNutritionalId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              PatientActionsContainer(
                title: 'Monitoring and \nEvaluation',
                icon: 'monitoring-evaluation',
                iconData: Icons.phone,
                color: const Color.fromARGB(255, 252, 67, 66),
                isSmall: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => MonitoringEvaluationPage(
                        appointmentId: widget.appointmentId,
                        doctorId: widget.doctorId,
                        patientId: widget.patientId,
                        patientNutritionalId: widget.patientNutritionalId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          Row(
            children: [
              PatientActionsContainer(
                title: 'Chat',
                icon: 'chat',
                iconData: Icons.phone,
                color: const Color.fromARGB(255, 253, 195, 10),
                isSmall: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ChatPage(
                        doctorId: widget.doctorId,
                        patientId: widget.patientId,
                        appointmentId: widget.appointmentId,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      )
    ];
  }

  @override
  void initState() {
    getPatientInfo();
    getPatientNutritionInfo();
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
