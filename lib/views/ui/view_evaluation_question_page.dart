import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay_nutritionist/models/question.dart';
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
  List<TextEditingController> _indicatorController = [];
  List<TextEditingController> _criteriaController = [];
  List<TextEditingController> _progressController = [];
  List<bool> isMarked = [];
  List<bool> isResolved = [];

  Future<void> getQuestions() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('form')
        .doc(widget.formId)
        .collection('questions')
        .withConverter(
          fromFirestore: Question.fromFirestore,
          toFirestore: (Question question, _) => question.toFirestore(),
        );

    await collection.get().then(
      (querySnapshot) {
        _indicatorController = List.generate(
            querySnapshot.docs.length, (i) => TextEditingController());
        _criteriaController = List.generate(
            snapshot.data!.docs.length, (i) => TextEditingController());
        _progressController = List.generate(
            snapshot.data!.docs.length, (i) => TextEditingController());
        isMarked = List.generate(snapshot.data!.docs.length, (i) => false);
        isResolved = List.generate(snapshot.data!.docs.length, (i) => false);
        for (var docSnapshot in querySnapshot.docs) {
          nutritionProfile = docSnapshot.data();
          hasData = nutritionProfile != null;
          setState(() {});
        }
      },
    );
  }

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
            "MNE",
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

                  // if (snapshot.hasData) {
                  //   _indicatorController = List.generate(
                  //       snapshot.data!.docs.length,
                  //       (i) => TextEditingController());
                  //   _criteriaController = List.generate(
                  //       snapshot.data!.docs.length,
                  //       (i) => TextEditingController());
                  //   _progressController = List.generate(
                  //       snapshot.data!.docs.length,
                  //       (i) => TextEditingController());
                  //   isMarked =
                  //       List.generate(snapshot.data!.docs.length, (i) => false);
                  //   isResolved =
                  //       List.generate(snapshot.data!.docs.length, (i) => false);
                  // }

                  int indicatorIndex = -1,
                      criteriaIndex = -1,
                      progressIndex = -1,
                      markedIndex = -1,
                      resolvedIndex = -1;

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

                                indicatorIndex++;
                                criteriaIndex++;
                                progressIndex++;
                                markedIndex++;
                                resolvedIndex++;

                                _indicatorController[indicatorIndex].text =
                                    data['indicator'];
                                _criteriaController[criteriaIndex].text =
                                    data['criteria'];
                                _progressController[progressIndex].text =
                                    data['progress'];
                                isMarked[markedIndex] = data['marked'];
                                isResolved[resolvedIndex] = data['resolved'];

                                return SizedBox(
                                  height: 400,
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
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Indicator ${indicatorIndex + 1}',
                                                style: appstyle(
                                                    14,
                                                    Colors.black,
                                                    FontWeight.bold),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _indicatorController
                                                          .removeAt(
                                                              indicatorIndex);
                                                      _criteriaController
                                                          .removeAt(
                                                              indicatorIndex);
                                                      _progressController
                                                          .removeAt(
                                                              indicatorIndex);
                                                      isMarked.removeAt(
                                                          indicatorIndex);
                                                      isResolved.removeAt(
                                                          indicatorIndex);
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
                                            controller: _indicatorController[
                                                criteriaIndex],
                                            keyboardType: TextInputType.text,
                                            style: appstyle(14, Colors.black,
                                                FontWeight.normal),
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
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              hintText: 'Input the indicator',
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
                                          child: Text(
                                            'Criteria ${criteriaIndex + 1}',
                                            style: appstyle(14, Colors.black,
                                                FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, left: 10, right: 10),
                                          width: double.infinity,
                                          child: TextFormField(
                                            controller: _criteriaController[
                                                criteriaIndex],
                                            keyboardType: TextInputType.text,
                                            style: appstyle(14, Colors.black,
                                                FontWeight.normal),
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
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              hintText: 'Input the criteria',
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
                                          child: Text(
                                            'Progress Notes',
                                            style: appstyle(14, Colors.black,
                                                FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          child: TextFormField(
                                            controller: _progressController[
                                                progressIndex],
                                            keyboardType:
                                                TextInputType.multiline,
                                            validator: (value) {
                                              return null;
                                            },
                                            enabled: true,
                                            decoration: InputDecoration(
                                              hintText: 'Input the progress',
                                              hintStyle: appstyle(
                                                  14,
                                                  Colors.black,
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
                                              //       style: appstyle(
                                              //           14,
                                              //           Colors.black,
                                              //           FontWeight.normal),
                                              //     ),
                                              //     value: isMarked[markedIndex],
                                              //     onChanged: (newValue) {
                                              //       setState(() {
                                              //         isMarked[markedIndex] =
                                              //             newValue!;
                                              //       });
                                              //     },
                                              //     controlAffinity:
                                              //         ListTileControlAffinity
                                              //             .leading, //  <-- leading Checkbox
                                              //   ),
                                              // ),
                                              Expanded(
                                                child: CheckboxListTile(
                                                  title: Text(
                                                    "Resolved",
                                                    style: appstyle(
                                                        14,
                                                        Colors.black,
                                                        FontWeight.normal),
                                                  ),
                                                  value:
                                                      isResolved[resolvedIndex],
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      isResolved[
                                                              resolvedIndex] =
                                                          newValue!;
                                                    });
                                                  },
                                                  controlAffinity:
                                                      ListTileControlAffinity
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
