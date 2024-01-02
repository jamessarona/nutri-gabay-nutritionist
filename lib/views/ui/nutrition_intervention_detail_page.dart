import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_gabay_nutritionist/models/comment.dart';
import 'package:nutri_gabay_nutritionist/models/doctor.dart';
import 'package:nutri_gabay_nutritionist/models/patient.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:timeago/timeago.dart' as timeago;

class NutritionInterventionDetailPage extends StatefulWidget {
  final String appointmentId;
  final String patientNutritionalId;
  final String doctorId;
  final String patientId;
  final String fileId;
  final String fileType;
  final String fileName;
  final String fileDate;
  final double fileSize;
  final String fileUrl;
  const NutritionInterventionDetailPage({
    super.key,
    required this.appointmentId,
    required this.patientNutritionalId,
    required this.doctorId,
    required this.patientId,
    required this.fileId,
    required this.fileType,
    required this.fileName,
    required this.fileDate,
    required this.fileSize,
    required this.fileUrl,
  });

  @override
  State<NutritionInterventionDetailPage> createState() =>
      _NutritionInterventionDetailPageState();
}

class _NutritionInterventionDetailPageState
    extends State<NutritionInterventionDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  late Size screenSize;

  Patient? patient;
  Doctor? doctor;

  Future<void> getDoctorInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("doctor")
        .doc(widget.doctorId)
        .withConverter(
          fromFirestore: Doctor.fromFirestore,
          toFirestore: (Doctor dtr, _) => dtr.toFirestore(),
        );

    final docSnap = await ref.get();
    doctor = docSnap.data()!;
    setState(() {});
  }

  Future<void> getPatientInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("patient")
        .doc(widget.patientId)
        .withConverter(
          fromFirestore: Patient.fromFirestore,
          toFirestore: (Patient pt, _) => pt.toFirestore(),
        );

    final docSnap = await ref.get();
    patient = docSnap.data()!;
    setState(() {});
  }

  Future<void> submitComment() async {
    if (_formKey.currentState!.validate()) {
      await saveToFirebase();
    }
  }

  Future<void> saveToFirebase() async {
    final docComment = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(widget.fileId)
        .collection('comments')
        .doc();
    Comment comment = Comment(
      id: docComment.id,
      isPatient: false,
      text: _commentController.text,
      date: DateTime.now(),
    );

    final formJson = comment.toJson();
    await docComment.set(formJson);
  }

  showAlertDialog(BuildContext context, String fileId) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: appstyle(14, Colors.black, FontWeight.normal),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
      child: Text(
        "Delete",
        style: appstyle(14, Colors.red, FontWeight.bold),
      ),
      onPressed: () async {
        await deleteFile(fileId);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmation",
        style: appstyle(15, Colors.black, FontWeight.bold),
      ),
      content: Text(
        "Are you sure you want to delete this file?",
        style: appstyle(13, Colors.black, FontWeight.normal),
      ),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> deleteFile(String id) async {
    try {
      final parentCollection =
          FirebaseFirestore.instance.collection('appointment');

      final document = parentCollection
          .doc(widget.appointmentId)
          .collection('files')
          .doc(id);

      await document.delete();
      setState(() {});
      // ignore: empty_catches
    } on FirebaseException {}
  }

  Future<void> getNewComments() async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(widget.fileId)
        .collection('comments')
        .where(
          Filter.and(
            Filter("isPatient", isEqualTo: true),
            Filter(
              "isSeen",
              isEqualTo: false,
            ),
          ),
        );

    await collection.get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await updateSeenComments(docSnapshot.data()["id"]);
        }
      },
    );
  }

  Future<void> updateSeenComments(String commentId) async {
    await FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('files')
        .doc(widget.fileId)
        .collection('comments')
        .doc(commentId)
        .update(
      {'isSeen': true},
    );
  }

  @override
  void initState() {
    getNewComments();
    getDoctorInfo();
    getPatientInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "File",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: doctor == null || patient == null
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
                          GestureDetector(
                            onTap: () {
                              launchUrlString(widget.fileUrl);
                            },
                            child: SizedBox(
                              height: 90,
                              child: Card(
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 10),
                                    Icon(
                                      widget.fileType == 'application/pdf'
                                          ? FontAwesomeIcons.filePdf
                                          : FontAwesomeIcons.fileImage,
                                      color: widget.fileType ==
                                              'application/pdf'
                                          ? const Color.fromARGB(
                                              255, 201, 126, 121)
                                          : const Color.fromARGB(
                                              255, 115, 163, 201),
                                      size: 50,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.fileName,
                                            style: appstyle(
                                              14,
                                              Colors.black,
                                              FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            widget.fileDate,
                                            style: appstyle(
                                              11,
                                              Colors.black,
                                              FontWeight.normal,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.visible,
                                          ),
                                          Text(
                                            '${widget.fileSize.toStringAsFixed(2)} KB',
                                            style: appstyle(
                                              11,
                                              Colors.black,
                                              FontWeight.normal,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      alignment: Alignment.topRight,
                                      onPressed: () async {
                                        showAlertDialog(context, widget.fileId);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.trashCan,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Comments',
                              style:
                                  appstyle(13, Colors.black, FontWeight.normal),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('appointment')
                                    .doc(widget.appointmentId)
                                    .collection('files')
                                    .doc(widget.fileId)
                                    .collection('comments')
                                    .orderBy("date", descending: false)
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
                                  return Column(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                          Map<String, dynamic> data = document
                                              .data()! as Map<String, dynamic>;
                                          return Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: CircleAvatar(
                                                    radius: 30.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            data['isPatient'] ==
                                                                    true
                                                                ? patient!.image
                                                                : doctor!
                                                                    .image),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                SizedBox(
                                                  width: screenSize.width * 0.7,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data['isPatient'] ==
                                                                true
                                                            ? '${patient!.firstname} ${patient!.lastname}'
                                                            : doctor!.name,
                                                        style: appstyle(
                                                            12,
                                                            Colors.black,
                                                            FontWeight.bold),
                                                      ),
                                                      const SizedBox(height: 3),
                                                      Text(
                                                        data['text'],
                                                        style: appstyle(
                                                            12,
                                                            Colors.black,
                                                            FontWeight.normal),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                      Text(
                                                        timeago.format(
                                                          data['date'].toDate(),
                                                        ),
                                                        style: appstyle(
                                                            10,
                                                            Colors.black,
                                                            FontWeight.normal),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                        .toList()
                                        .cast(),
                                  );
                                }),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add a Comment:',
                                  style: appstyle(
                                      13, Colors.black, FontWeight.normal),
                                ),
                                const SizedBox(height: 5),
                                Form(
                                  key: _formKey,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 40,
                                          child: TextFormField(
                                            controller: _commentController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value == '') {
                                                return 'please add a comment';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                    color: customColor),
                                              ),
                                              hintStyle: appstyle(
                                                  12,
                                                  Colors.black,
                                                  FontWeight.w500),
                                              labelStyle: appstyle(
                                                  12,
                                                  Colors.black,
                                                  FontWeight.w500),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 5.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      IconButton(
                                        onPressed: () async {
                                          await submitComment().then((value) {
                                            _commentController.clear();
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.arrow_circle_right_rounded,
                                          size: 30,
                                          color: customColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
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
