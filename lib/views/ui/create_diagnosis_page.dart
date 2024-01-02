import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutri_gabay_nutritionist/models/diagnosis.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_container.dart';

class CreateDiagnosisPage extends StatefulWidget {
  final String appointmentId;
  const CreateDiagnosisPage({
    super.key,
    required this.appointmentId,
  });

  @override
  State<CreateDiagnosisPage> createState() => _CreateDiagnosisPageState();
}

class _CreateDiagnosisPageState extends State<CreateDiagnosisPage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _domain1Controller = TextEditingController();
  final TextEditingController _domain2Controller = TextEditingController();
  final TextEditingController _domain3Controller = TextEditingController();
  final TextEditingController _domain4Controller = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _statementController = TextEditingController();

  void saveDiagnosis() async {
    if (_formKey.currentState!.validate()) {
      await saveToFirebase().whenComplete(() {
        final snackBar = SnackBar(
          content: Text(
            'Diagnosis has been saved',
            style: appstyle(12, Colors.white, FontWeight.normal),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> saveToFirebase() async {
    final docDiagnosis = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('diagnosis')
        .doc();

    Diagnosis formQuestion = Diagnosis(
      id: docDiagnosis.id,
      domain1: _domain1Controller.text,
      domain2: _domain2Controller.text,
      domain3: _domain3Controller.text,
      domain4: _domain4Controller.text,
      problem: _problemController.text,
      statement: _statementController.text,
      date: DateTime.now(),
      isSeen: false,
    );

    final formJson = formQuestion.toJson();
    await docDiagnosis.set(formJson);
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
            "Nutrition Diagnosis",
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
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
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
                          DiagnosisDomainContainer(
                            controller: _domain1Controller,
                            validation: (value) {
                              return null;
                            },
                            isEdit: true,
                          ),
                          const SizedBox(width: 15),
                          DiagnosisDomainContainer(
                            controller: _domain2Controller,
                            validation: (value) {
                              return null;
                            },
                            isEdit: true,
                          ),
                          const SizedBox(width: 15),
                          DiagnosisDomainContainer(
                            controller: _domain3Controller,
                            validation: (value) {
                              return null;
                            },
                            isEdit: true,
                          ),
                          const SizedBox(width: 15),
                          DiagnosisDomainContainer(
                            controller: _domain4Controller,
                            validation: (value) {
                              return null;
                            },
                            isEdit: true,
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: customColor),
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: customColor),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                      ),
                      maxLines: 10,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      child: CustomButton(
                        onPress: () {
                          saveDiagnosis();
                        },
                        label: 'Submit',
                        labelSize: 15,
                        radius: 5,
                      ),
                    ),
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
