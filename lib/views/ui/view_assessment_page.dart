import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/models/assessment.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class ViewAssessmentPage extends StatefulWidget {
  final String appointmentId;
  final String assessmentId;
  final String assessmentName;
  const ViewAssessmentPage(
      {super.key,
      required this.appointmentId,
      required this.assessmentId,
      required this.assessmentName});

  @override
  State<ViewAssessmentPage> createState() => _ViewAssessmentPageState();
}

class _ViewAssessmentPageState extends State<ViewAssessmentPage> {
  late Size screenSize;

  Assessment? assessment;
  Future<void> getAssessment() async {
    final ref = FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentId)
        .collection('assessment')
        .doc(widget.assessmentId)
        .withConverter(
          fromFirestore: Assessment.fromFirestore,
          toFirestore: (Assessment asmt, _) => asmt.toFirestore(),
        );
    final docSnap = await ref.get();
    assessment = docSnap.data()!;

    setState(() {});
  }

  @override
  void initState() {
    getAssessment();
    super.initState();
  }

  Widget buildFirstWidget() {
    return Column(
      children: [
        SizedBox(
          width:
              screenSize.width > 600 ? screenSize.width * .48 : double.infinity,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client History (CH)',
                    style: appstyle(
                      20,
                      Colors.black,
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Patient/client or family nutrition‐oriented medical/health history:',
                    style: appstyle(
                      15,
                      Colors.black,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    assessment!.history,
                    style: appstyle(
                      14,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Living/housing situation:',
                    style: appstyle(
                      15,
                      Colors.black,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    assessment!.situation,
                    style: appstyle(
                      14,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Occupation:',
                    style: appstyle(
                      15,
                      Colors.black,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    assessment!.occupation,
                    style: appstyle(
                      14,
                      Colors.black,
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width:
              screenSize.width > 600 ? screenSize.width * .48 : double.infinity,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nutrition‐ Focused Physical Findings (PD)',
                    style: appstyle(
                      20,
                      Colors.black,
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    assessment!.findings,
                    style: appstyle(
                      14,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width:
              screenSize.width > 600 ? screenSize.width * .48 : double.infinity,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comparative Standards (CS)',
                    style: appstyle(
                      20,
                      Colors.black,
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    assessment!.standards,
                    style: appstyle(
                      14,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSecondWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width:
              screenSize.width > 600 ? screenSize.width * .48 : double.infinity,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Food/ Nutrition‐ Related History (FH)',
                    style: appstyle(
                      20,
                      Colors.black,
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    assessment!.relatedHistory,
                    style: appstyle(
                      14,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width:
              screenSize.width > 600 ? screenSize.width * .48 : double.infinity,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biochemical Data, Medical Tests and Procedures (BD)',
                    style: appstyle(
                      20,
                      Colors.black,
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    assessment!.procedures,
                    style: appstyle(
                      14,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width:
              screenSize.width > 600 ? screenSize.width * .48 : double.infinity,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anthropometric Measurements (AD)',
                    style: appstyle(
                      20,
                      Colors.black,
                      FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    assessment!.measurements,
                    style: appstyle(
                      14,
                      Colors.black,
                      FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
            'Readiness to change nutrition‐related behaviors: Motivation (Scales 1‐10)',
            style: appstyle(
              13,
              Colors.black,
              FontWeight.w600,
            )),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              height: 20,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                ),
                color: Colors.grey.shade200,
              ),
              alignment: Alignment.center,
              child: Text(
                assessment!.change.toString(),
                style: appstyle(
                  13,
                  Colors.black,
                  FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'I think it is important to make change',
              style: appstyle(
                13,
                Colors.black,
                FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              height: 20,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                ),
                color: Colors.grey.shade200,
              ),
              alignment: Alignment.center,
              child: Text(
                assessment!.success.toString(),
                style: appstyle(
                  13,
                  Colors.black,
                  FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'I am sure that I will success',
              style: appstyle(
                13,
                Colors.black,
                FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              height: 20,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: Colors.grey,
                ),
                color: Colors.grey.shade200,
              ),
              alignment: Alignment.center,
              child: Text(
                assessment!.start.toString(),
                style: appstyle(
                  13,
                  Colors.black,
                  FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'I am ready to start',
              style: appstyle(
                13,
                Colors.black,
                FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
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
            "Assessment",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.01,
        ),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.assessmentName,
              style: appstyle(
                20,
                Colors.black,
                FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            assessment == null
                ? const Center(child: CircularProgressIndicator())
                : screenSize.width > 600
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildFirstWidget(),
                          buildSecondWidget(),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildFirstWidget(),
                          buildSecondWidget(),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
