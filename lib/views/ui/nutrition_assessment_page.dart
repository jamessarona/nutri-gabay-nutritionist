import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class NutritionAssessmentPage extends StatefulWidget {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String patientNutritionalId;
  const NutritionAssessmentPage({
    super.key,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.patientNutritionalId,
  });

  @override
  State<NutritionAssessmentPage> createState() =>
      _NutritionAssessmentPageState();
}

class _NutritionAssessmentPageState extends State<NutritionAssessmentPage> {
  late Size screenSize;
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
            "Assessment",
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
      ),
    );
  }
}
