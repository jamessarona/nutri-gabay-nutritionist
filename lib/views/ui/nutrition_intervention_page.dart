import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:nutri_gabay_nutritionist/views/shared/custom_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NutritionInterventionPage extends StatefulWidget {
  final String appointmentId;
  final String patientNutritionalId;
  const NutritionInterventionPage(
      {super.key,
      required this.appointmentId,
      required this.patientNutritionalId});

  @override
  State<NutritionInterventionPage> createState() =>
      _NutritionInterventionPageState();
}

class _NutritionInterventionPageState extends State<NutritionInterventionPage> {
  late Size screenSize;
  late DropzoneViewController controller;

  String? fileName;
  String? fileMime;
  int? fileBytes;
  Uint8List webImage = Uint8List(8);

  bool isHighlighted = false;

  Future acceptFile(dynamic event) async {
    if (['application/pdf', 'image/png']
        .contains(await controller.getFileMIME(event))) {
      fileName = event.name;
      fileMime = await controller.getFileMIME(event);
      fileBytes = await controller.getFileSize(event);
      webImage = await controller.getFileData(event);
    } else {
      final snackBar = SnackBar(
        content: Text(
          'This is not a valid file type',
          style: appstyle(12, Colors.white, FontWeight.normal),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isHighlighted = false;
    });
  }

  Widget buildFileUploaderWidget() {
    return Container(
      width: screenSize.width > 500 ? screenSize.width * .45 : double.infinity,
      height: screenSize.width > screenSize.height * 0.7
          ? screenSize.height * 0.7
          : screenSize.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.green.shade100 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: Colors.black38,
        strokeWidth: 1,
        padding: EdgeInsets.zero,
        dashPattern: const [8, 4],
        radius: const Radius.circular(10),
        child: kIsWeb
            ? Stack(
                alignment: Alignment.center,
                children: [
                  DropzoneView(
                    onCreated: (controller) => this.controller = controller,
                    onHover: () => setState(() => isHighlighted = true),
                    onLeave: () => setState(() => isHighlighted = false),
                    onDrop: acceptFile,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 120,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Drop your file here',
                        style: appstyle(20, Colors.black, FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'or ',
                            style: appstyle(20, Colors.black, FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final events = await controller.pickFiles();
                              if (events.isEmpty) return;

                              acceptFile(events.first);
                            },
                            child: Text(
                              'Browse',
                              style: appstyle(20, customColor, FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      fileName != null
                          ? Text(
                              fileName!,
                              style:
                                  appstyle(15, Colors.black, FontWeight.normal),
                              textAlign: TextAlign.center,
                            )
                          : Container()
                    ],
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget buildFiles() {
    return SizedBox(
      width: screenSize.width > 500 ? screenSize.width * .45 : double.infinity,
      height: screenSize.width > screenSize.height * 0.7
          ? screenSize.height * 0.7
          : screenSize.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointment')
            .doc(widget.appointmentId)
            .collection('files')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return ListView(
            children: snapshot.data!.docs
                .map(
                  (DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        launchUrlString(data['url']);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 90,
                        child: Card(
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10),
                              Icon(
                                data['type'] == 'application/pdf'
                                    ? FontAwesomeIcons.filePdf
                                    : FontAwesomeIcons.fileImage,
                                color: data['type'] == 'application/pdf'
                                    ? const Color.fromARGB(255, 201, 126, 121)
                                    : const Color.fromARGB(255, 115, 163, 201),
                                size: 50,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'],
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
                                      formatDate(data['date']),
                                      style: appstyle(
                                        11,
                                        Colors.black,
                                        FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      '${data['size'].toStringAsFixed(2)} KB',
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
                                  showAlertDialog(context, data['id']);
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
                    );
                  },
                )
                .toList()
                .cast(),
          );
        },
      ),
    );
  }

  Future<void> uploadFile() async {
    if (fileName != null && fileMime != null && fileBytes != null) {
      await saveToDatabase();
    } else {
      await pickFile();
    }
  }

  Future pickFile() async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickMedia();
      if (image != null) {
        if (['application/pdf', 'image/png'].contains(image.mimeType)) {
          var f = await image.readAsBytes();
          webImage = f;
          fileName = image.name;
          fileMime = image.mimeType;
          fileBytes = f.lengthInBytes;
          setState(() {});
          uploadFile();
        } else {
          final snackBar = SnackBar(
            content: Text(
              'This is not a valid file type',
              style: appstyle(12, Colors.white, FontWeight.normal),
            ),
            action: SnackBarAction(
              label: 'Close',
              onPressed: () {},
            ),
          );
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }

  Future<void> saveToDatabase() async {
    DateTime now = DateTime.now();
    try {
      final parentCollection =
          FirebaseFirestore.instance.collection('appointment');

      final document =
          parentCollection.doc(widget.appointmentId).collection('files').doc();

      await document.set({
        'id': document.id,
        'name': fileName,
        'size': (fileBytes! * 0.001),
        'type': fileMime,
        'date': now.toString(),
        'url': '',
      }).whenComplete(() async {
        await saveToStorage(document.id);
      });
      // ignore: empty_catches
    } on FirebaseException {}
  }

  Future<void> saveToStorage(String fileId) async {
    try {
      var snapshot = await FirebaseStorage.instance
          .ref(
              'files/appointment/interventions/${widget.appointmentId}/$fileId/$fileName')
          .putData(
            webImage,
            SettableMetadata(contentType: fileMime),
          );

      var downloadUrl = await snapshot.ref.getDownloadURL();

      await saveUrlToDatabase(fileId, downloadUrl);
      // ignore: empty_catches
    } on FirebaseException {}
  }

  Future<void> saveUrlToDatabase(String fileId, String downloadUrl) async {
    try {
      final parentCollection =
          FirebaseFirestore.instance.collection('appointment');

      final document = parentCollection
          .doc(widget.appointmentId)
          .collection('files')
          .doc(fileId);

      await document.update({
        'url': downloadUrl,
      });
      fileName = null;
      fileMime = null;
      fileBytes = null;
      setState(() {});
      // ignore: empty_catches
    } on FirebaseException {}
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

  String formatDate(String date) {
    String format = '';
    DateTime day = DateFormat('yyyy-MM-dd hh:mm:ss').parse(date);

    format =
        '${day.month}/${day.day}/${day.year} ${day.hour < 13 ? day.hour : (day.hour - 12).toStringAsFixed(0)}:${day.minute} ${day.hour < 13 ? 'AM' : 'PM'}';
    return format;
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

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "Files",
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
          child: ListView(
            children: [
              const SizedBox(height: 60),
              Container(
                margin:
                    EdgeInsets.symmetric(horizontal: screenSize.width * 0.01),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                constraints: BoxConstraints(minHeight: screenSize.height * 0.8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: 'UPLOAD ',
                                  style: appstyle(
                                      18, customColor, FontWeight.bold)),
                              TextSpan(
                                  text: 'FILES ',
                                  style: appstyle(
                                      18, Colors.black, FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: CustomButton(
                            onPress: () {
                              uploadFile().whenComplete(() {
                                setState(() {});
                              });
                            },
                            label: 'Upload',
                            labelSize: 15,
                            radius: 5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    screenSize.width > 500
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildFileUploaderWidget(),
                              buildFiles(),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildFileUploaderWidget(),
                              buildFiles(),
                            ],
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
