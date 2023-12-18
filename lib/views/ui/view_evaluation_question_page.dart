import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';

class ViewEvaluationQuestionPage extends StatefulWidget {
  final String appointmentId;
  final String formId;
  final String formName;
  const ViewEvaluationQuestionPage(
      {super.key,
      required this.appointmentId,
      required this.formId,
      required this.formName});

  @override
  State<ViewEvaluationQuestionPage> createState() =>
      _ViewEvaluationQuestionPageState();
}

class _ViewEvaluationQuestionPageState
    extends State<ViewEvaluationQuestionPage> {
  late Size screenSize;

  final TextEditingController _formController = TextEditingController();
  List<TextEditingController> _questionController = [];
  List<TextEditingController> _typeController = [];

  @override
  void initState() {
    _formController.text = widget.formName;
    super.initState();
  }

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
      body: Form(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('appointment')
                    .doc(widget.appointmentId)
                    .collection('form')
                    .doc(widget.formId)
                    .collection('questions')
                    .orderBy('number')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Text('No Records');
                  }

                  if (snapshot.hasData) {
                    _questionController = List.generate(
                        snapshot.data!.docs.length,
                        (i) => TextEditingController());
                    _typeController = List.generate(snapshot.data!.docs.length,
                        (i) => TextEditingController());
                  }

                  int questionIndex = -1, typeIndex = -1;

                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: StaggeredGrid.count(
                          axisDirection: AxisDirection.down,
                          crossAxisCount: screenSize.width > 600 ? 2 : 1,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 1,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;

                                questionIndex++;
                                typeIndex++;

                                _questionController[questionIndex].text =
                                    data['question'];
                                _typeController[typeIndex].text = data['type'];

                                return SizedBox(
                                  height: 200,
                                  child: Card(
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          width: double.infinity,
                                          child: TextFormField(
                                            controller: _questionController[
                                                questionIndex],
                                            keyboardType: TextInputType.text,
                                            style: appstyle(14, Colors.black,
                                                FontWeight.normal),
                                            enabled: false,
                                            validator: (value) {
                                              if (value == '') {
                                                return 'Please enter the question';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              hintText:
                                                  'Question ${questionIndex + 1}',
                                              hintStyle: appstyle(
                                                  14,
                                                  Colors.black,
                                                  FontWeight.normal),
                                              fillColor: Colors.grey.shade200,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 5),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          width: double.infinity,
                                          child: TextFormField(
                                            controller:
                                                _typeController[typeIndex],
                                            keyboardType: TextInputType.none,
                                            style: appstyle(14, Colors.black,
                                                FontWeight.normal),
                                            validator: (value) {
                                              if (value == '') {
                                                return 'Select the question type';
                                              }
                                              return null;
                                            },
                                            enabled: false,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              suffixIcon:
                                                  PopupMenuButton<String>(
                                                icon: const Icon(
                                                    Icons.arrow_drop_down),
                                                onSelected: (String value) {
                                                  _typeController[typeIndex]
                                                      .text = value;
                                                },
                                                itemBuilder:
                                                    (BuildContext context) {
                                                  return [
                                                    "Short answer text",
                                                    "Image"
                                                  ].map<PopupMenuItem<String>>(
                                                      (String value) {
                                                    return PopupMenuItem(
                                                        value: value,
                                                        child: Text(value));
                                                  }).toList();
                                                },
                                              ),
                                              filled: true,
                                              hintStyle: appstyle(
                                                  14,
                                                  Colors.black,
                                                  FontWeight.normal),
                                              fillColor: Colors.grey.shade200,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 5),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                "Answer: ",
                                                style: appstyle(
                                                    14,
                                                    Colors.black,
                                                    FontWeight.normal),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                data['answer'],
                                                style: appstyle(
                                                        14,
                                                        Colors.black,
                                                        FontWeight.bold)
                                                    .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                              .toList()
                              .cast(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
