import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_container.dart';
import 'package:nutri_gabay_nutritionist/views/ui/create_diagnosis_page.dart';
import 'package:nutri_gabay_nutritionist/views/ui/view_diagnosis_page.dart';

class NutritionDiagnosisPage extends StatefulWidget {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String patientNutritionalId;
  const NutritionDiagnosisPage({
    super.key,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.patientNutritionalId,
  });

  @override
  State<NutritionDiagnosisPage> createState() => _NutritionDiagnosisPageState();
}

class _NutritionDiagnosisPageState extends State<NutritionDiagnosisPage> {
  late Size screenSize;
  List<Widget> buildFormWidger(BuildContext context) {
    return [
      PatientActionsContainer(
        title: 'Create a Diagnosis',
        icon: 'add-form',
        iconData: Icons.phone,
        color: const Color.fromARGB(255, 253, 195, 10),
        isSmall: false,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CreateDiagnosisPage(
                appointmentId: widget.appointmentId,
              ),
            ),
          );
        },
      ),
      const SizedBox(width: 50, height: 50),
      PatientActionsContainer(
        title: 'Your Diagnosis',
        icon: 'forms',
        iconData: Icons.phone,
        color: const Color.fromARGB(255, 252, 67, 66),
        isSmall: false,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ViewDiagnosisPage(
                appointmentId: widget.appointmentId,
              ),
            ),
          );
        },
      ),
    ];
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
            "Diagnosis",
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
        child: screenSize.width < 600
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildFormWidger(context),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildFormWidger(context),
              ),
      ),
    );
  }
}
