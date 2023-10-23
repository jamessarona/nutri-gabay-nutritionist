import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nutri_gabay_nutritionist/models/patient.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_patient_tile.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_text_fields.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  late Size screenSize;
  String uid = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _search = TextEditingController();

  List<QueryDocumentSnapshot<Patient>>? patients;

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

  @override
  void initState() {
    getNutritionistId();
    getPatients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 60),
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
                'Patients',
                style: appstyle(
                  25,
                  Colors.black,
                  FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.01),
                      height: 40,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 200,
                            child: SearchTextField(
                              controller: _search,
                              hintText: 'Search patient...',
                              isObscure: false,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              isEditable: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.01),
                      height: 750,
                      width: double.infinity,
                      child: Card(
                        child: uid != ''
                            ? StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('appointment')
                                    .where(
                                      Filter.and(
                                          Filter("status",
                                              isEqualTo: "Accepted"),
                                          Filter("doctorId", isEqualTo: uid)),
                                    )
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (!snapshot.hasData) {
                                    return const Text('No Records');
                                  }
                                  return ListView(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    children: [
                                      StaggeredGrid.count(
                                        axisDirection: AxisDirection.right,
                                        crossAxisCount: 8,
                                        mainAxisSpacing: 0,
                                        crossAxisSpacing: 0,
                                        children: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                              Map<String, dynamic> data =
                                                  document.data()!
                                                      as Map<String, dynamic>;

                                              return StaggeredGridTile.count(
                                                crossAxisCellCount: 1,
                                                mainAxisCellCount: 4,
                                                child: CustomPatientTile(
                                                  appointmentId: data['id'],
                                                  patientId: data['patientId'],
                                                  patientNutritionalId: data[
                                                      'patientNutritionalId'],
                                                  name: getPatientInfoByField(
                                                      data['patientId'],
                                                      'name'),
                                                  image: getPatientInfoByField(
                                                      data['patientId'],
                                                      'image'),
                                                ),
                                              );
                                            })
                                            .toList()
                                            .cast(),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
