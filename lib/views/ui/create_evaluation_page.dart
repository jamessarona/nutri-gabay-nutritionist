import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay_nutritionist/models/form.dart';
import 'package:nutri_gabay_nutritionist/models/question.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';

class CreateEvaluationPage extends StatefulWidget {
  final String appointmentId;
  const CreateEvaluationPage({
    super.key,
    required this.appointmentId,
  });

  @override
  State<CreateEvaluationPage> createState() => _CreateEvaluationPageState();
}

class _CreateEvaluationPageState extends State<CreateEvaluationPage> {
  late Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _formController = TextEditingController();
  final List<TextEditingController> _indicatorController = [];
  final List<TextEditingController> _criteriaController = [];
  final List<TextEditingController> _progressController = [];
  final List<bool> isMarked = [];
  final List<bool> isResolved = [];

  void saveForm() async {
    if (_formKey.currentState!.validate()) {
      await saveToFirebase().whenComplete(() {
        final snackBar = SnackBar(
          content: Text(
            'MNE has been saved',
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
    if (_indicatorController.isNotEmpty) {
      final docForm = FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.appointmentId)
          .collection('form')
          .doc();

      FormQuestion formQuestion = FormQuestion(
        id: docForm.id,
        name: _formController.text,
        date: DateTime.now(),
        answered: false,
        isSeen: false,
      );

      final formJson = formQuestion.toJson();
      await docForm.set(formJson);
      for (int i = 0; i < _indicatorController.length; i++) {
        final docForm = FirebaseFirestore.instance
            .collection('appointment')
            .doc(widget.appointmentId)
            .collection('form')
            .doc(formQuestion.id)
            .collection('questions')
            .doc();
        Question questions = Question(
          uid: docForm.id,
          formId: formQuestion.id,
          number: i + 1,
          indicator: _indicatorController[i].text,
          criteria: _criteriaController[i].text,
          progress: _progressController[i].text,
          marked: isMarked[i],
          resolved: isResolved[i],
        );
        final questionsJson = questions.toJson();
        await docForm.set(questionsJson);
      }
    }
  }

  @override
  void initState() {
    _indicatorController.add(TextEditingController());
    _criteriaController.add(TextEditingController());
    _progressController.add(TextEditingController());
    isMarked.add(false);
    isResolved.add(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: customColor[10],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "Create MNE",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 300,
                margin: const EdgeInsets.only(top: 20, left: 20),
                child: TextFormField(
                  controller: _formController,
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter the form name';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  style: appstyle(20, Colors.black, FontWeight.bold),
                  decoration: InputDecoration(
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: customColor),
                    ),
                    hintText: 'Input Name for Form',
                    hintStyle: appstyle(20, Colors.black, FontWeight.bold),
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: double.infinity,
                  width: double.infinity,
                  child: ListView(
                    children: [
                      StaggeredGrid.count(
                        axisDirection: AxisDirection.down,
                        crossAxisCount: screenSize.width > 600 ? 2 : 1,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 1,
                        children:
                            List.generate(_indicatorController.length, (index) {
                          return SizedBox(
                            height: 400,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Indicator ${index + 1}',
                                          style: appstyle(14, Colors.black,
                                              FontWeight.bold),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _indicatorController
                                                    .removeAt(index);
                                                _criteriaController
                                                    .removeAt(index);
                                                _progressController
                                                    .removeAt(index);
                                                isMarked.removeAt(index);
                                                isResolved.removeAt(index);
                                              });
                                            },
                                            child: const Icon(
                                              FontAwesomeIcons.xmark,
                                              size: 30,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, left: 10, right: 10),
                                    width: double.infinity,
                                    child: TextFormField(
                                      controller: _indicatorController[index],
                                      keyboardType: TextInputType.text,
                                      style: appstyle(
                                          14, Colors.black, FontWeight.normal),
                                      validator: (value) {
                                        if (value == '') {
                                          return 'Please enter the indicator';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        hintText: 'Input the indicator',
                                        hintStyle: appstyle(14, Colors.black,
                                            FontWeight.normal),
                                        fillColor: Colors.grey.shade200,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Text(
                                      'Criteria ${index + 1}',
                                      style: appstyle(
                                          14, Colors.black, FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, left: 10, right: 10),
                                    width: double.infinity,
                                    child: TextFormField(
                                      controller: _criteriaController[index],
                                      keyboardType: TextInputType.text,
                                      style: appstyle(
                                          14, Colors.black, FontWeight.normal),
                                      validator: (value) {
                                        if (value == '') {
                                          return 'Please enter the criteria';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        hintText: 'Input the criteria',
                                        hintStyle: appstyle(14, Colors.black,
                                            FontWeight.normal),
                                        fillColor: Colors.grey.shade200,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Text(
                                      'Progress Notes',
                                      style: appstyle(
                                          14, Colors.black, FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: TextFormField(
                                      controller: _progressController[index],
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) {
                                        return null;
                                      },
                                      enabled: true,
                                      decoration: InputDecoration(
                                        hintText: 'Input the progress',
                                        hintStyle: appstyle(14, Colors.black,
                                            FontWeight.normal),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: const BorderSide(
                                              color: customColor),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white70,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 10.0),
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        // Expanded(
                                        //   child: CheckboxListTile(
                                        //     title: Text(
                                        //       "Marked",
                                        //       style: appstyle(14, Colors.black,
                                        //           FontWeight.normal),
                                        //     ),
                                        //     value: isMarked[index],
                                        //     onChanged: (newValue) {
                                        //       setState(() {
                                        //         isMarked[index] = newValue!;
                                        //       });
                                        //     },
                                        //     controlAffinity: ListTileControlAffinity
                                        //         .leading, //  <-- leading Checkbox
                                        //   ),
                                        // ),
                                        Expanded(
                                          child: CheckboxListTile(
                                            title: Text(
                                              "Resolved",
                                              style: appstyle(14, Colors.black,
                                                  FontWeight.normal),
                                            ),
                                            value: isResolved[index],
                                            onChanged: (newValue) {
                                              setState(() {
                                                isResolved[index] = newValue!;
                                              });
                                            },
                                            controlAffinity: ListTileControlAffinity
                                                .leading, //  <-- leading Checkbox
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                width: double.infinity,
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      child: CustomButton(
                        onPress: () {
                          setState(() {
                            _indicatorController.add(TextEditingController());
                            _criteriaController.add(TextEditingController());
                            _progressController.add(TextEditingController());
                            isMarked.add(false);
                            isResolved.add(false);
                          });
                        },
                        label: 'Add Indicator',
                        labelSize: 15,
                        radius: 5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      child: CustomButton(
                        onPress: () {
                          saveForm();
                        },
                        label: 'Save',
                        labelSize: 15,
                        radius: 5,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
