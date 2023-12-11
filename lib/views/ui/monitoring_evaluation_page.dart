import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_container.dart';
import 'package:nutri_gabay_nutritionist/views/ui/create_evaluation_page.dart';

class MonitoringEvaluationPage extends StatefulWidget {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String patientNutritionalId;
  const MonitoringEvaluationPage({
    super.key,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.patientNutritionalId,
  });

  @override
  State<MonitoringEvaluationPage> createState() =>
      _MonitoringEvaluationPageState();
}

class _MonitoringEvaluationPageState extends State<MonitoringEvaluationPage> {
  late Size screenSize;
  List<Widget> buildFormWidger(BuildContext context) {
    return [
      PatientActionsContainer(
        title: 'Create a form',
        icon: 'add-form',
        iconData: Icons.phone,
        color: const Color.fromARGB(255, 253, 195, 10),
        isSmall: false,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CreateEvaluationPage(
                appointmentId: widget.appointmentId,
              ),
            ),
          );
        },
      ),
      const SizedBox(width: 50, height: 50),
      PatientActionsContainer(
        title: 'Forms',
        icon: 'forms',
        iconData: Icons.phone,
        color: const Color.fromARGB(255, 252, 67, 66),
        isSmall: false,
        onTap: () {},
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
            "Forms",
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
