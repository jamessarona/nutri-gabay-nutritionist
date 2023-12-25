import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/models/diagnosis.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_container.dart';

class ViewDiagnosisAnswerPage extends StatefulWidget {
  final String appointmentId;
  final String diagnosisId;
  final String diagnosisName;
  const ViewDiagnosisAnswerPage({
    super.key,
    required this.appointmentId,
    required this.diagnosisId,
    required this.diagnosisName,
  });

  @override
  State<ViewDiagnosisAnswerPage> createState() =>
      _ViewDiagnosisAnswerPageState();
}

class _ViewDiagnosisAnswerPageState extends State<ViewDiagnosisAnswerPage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _domain1Controller = TextEditingController();
  final TextEditingController _domain2Controller = TextEditingController();
  final TextEditingController _domain3Controller = TextEditingController();
  final TextEditingController _domain4Controller = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _statementController = TextEditingController();

  Diagnosis? diagnosis;

  Future<void> getDiagnosis() async {
    final ref = FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentId)
        .collection("diagnosis")
        .doc(widget.diagnosisId)
        .withConverter(
          fromFirestore: Diagnosis.fromFirestore,
          toFirestore: (Diagnosis diag, _) => diag.toFirestore(),
        );
    final docSnap = await ref.get();
    diagnosis = docSnap.data()!;

    _domain1Controller.text = diagnosis!.domain1;
    _domain2Controller.text = diagnosis!.domain2;
    _domain3Controller.text = diagnosis!.domain3;
    _domain4Controller.text = diagnosis!.domain4;
    _problemController.text = diagnosis!.problem;
    _statementController.text = diagnosis!.statement;
    setState(() {});
  }

  @override
  void initState() {
    getDiagnosis();
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
            "Diagnosis",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: diagnosis == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nutrition Diagnosis for Patient',
                            style: appstyle(
                              23,
                              Colors.black,
                              FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'DOMAIN',
                              style: appstyle(
                                20,
                                Colors.black,
                                FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _domain1Controller.text == ''
                                    ? Container()
                                    : DiagnosisDomainContainer(
                                        controller: _domain1Controller,
                                        validation: (value) {
                                          return null;
                                        },
                                        isEdit: false,
                                      ),
                                _domain2Controller.text == ''
                                    ? Container()
                                    : const SizedBox(width: 15),
                                _domain2Controller.text == ''
                                    ? Container()
                                    : DiagnosisDomainContainer(
                                        controller: _domain2Controller,
                                        validation: (value) {
                                          return null;
                                        },
                                        isEdit: false,
                                      ),
                                _domain3Controller.text == ''
                                    ? Container()
                                    : const SizedBox(width: 15),
                                _domain3Controller.text == ''
                                    ? Container()
                                    : DiagnosisDomainContainer(
                                        controller: _domain3Controller,
                                        validation: (value) {
                                          return null;
                                        },
                                        isEdit: false,
                                      ),
                                _domain4Controller.text == ''
                                    ? Container()
                                    : const SizedBox(width: 15),
                                _domain4Controller.text == ''
                                    ? Container()
                                    : DiagnosisDomainContainer(
                                        controller: _domain4Controller,
                                        validation: (value) {
                                          return null;
                                        },
                                        isEdit: false,
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Nutrition Problem(s)',
                            style: appstyle(
                              15,
                              Colors.black,
                              FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _problemController,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value == '') {
                                return 'This field is required';
                              }
                              return null;
                            },
                            enabled: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: customColor),
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                            ),
                            maxLines: 10,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'PES STATEMENT(S) Problem related to Etiology as evidenced by signs and symptoms.',
                            style: appstyle(
                              15,
                              Colors.black,
                              FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _statementController,
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if (value == '') {
                                return 'This field is required';
                              }
                              return null;
                            },
                            enabled: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: customColor),
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                            ),
                            maxLines: 10,
                          ),
                          const SizedBox(height: 30),
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
