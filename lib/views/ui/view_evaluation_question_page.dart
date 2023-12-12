import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class ViewEvaluationQuestionPage extends StatefulWidget {
  final String appointmentId;
  final String formId;
  const ViewEvaluationQuestionPage(
      {super.key, required this.appointmentId, required this.formId});

  @override
  State<ViewEvaluationQuestionPage> createState() =>
      _ViewEvaluationQuestionPageState();
}

class _ViewEvaluationQuestionPageState
    extends State<ViewEvaluationQuestionPage> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: customColor[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "Form",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
      ),
      // body: SizedBox(
      //   height: double.infinity,
      //   width: double.infinity,
      // ),
    );
  }
}
