import 'package:flutter/material.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _search = TextEditingController();
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
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.01),
                        constraints: const BoxConstraints(minHeight: 750),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: screenSize.width * 0.005,
                              right: screenSize.width * 0.005,
                              top: screenSize.width * 0.005,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomPatientTile(
                                        name: 'James Angelo Sarona', image: ''),
                                    CustomPatientTile(
                                        name: 'James Angelo Sarona', image: ''),
                                    CustomPatientTile(
                                        name: 'James Angelo Sarona', image: ''),
                                    CustomPatientTile(
                                        name: 'James Angelo Sarona', image: ''),
                                    CustomPatientTile(
                                        name: 'James Angelo Sarona', image: ''),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
