import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutri_gabay_nutritionist/models/appointment.dart';
import 'package:nutri_gabay_nutritionist/models/doctor.dart';
import 'package:nutri_gabay_nutritionist/models/message_controller.dart';
import 'package:nutri_gabay_nutritionist/models/patient.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatPage extends StatefulWidget {
  final String doctorId;
  final String patientId;
  final String appointmentId;
  const ChatPage({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Doctor? doctor;
  Patient? patient;
  Appointments? appointment;

  TextEditingController textController = TextEditingController();
  List<dynamic>? messages;

  void getAppointmentInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("appointment")
        .doc(widget.appointmentId)
        .withConverter(
          fromFirestore: Appointments.fromFirestore,
          toFirestore: (Appointments appointment, _) =>
              appointment.toFirestore(),
        );
    final docSnap = await ref.get();
    appointment = docSnap.data()!;
    setState(() {});
  }

  void getDoctortInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("doctor")
        .doc(widget.doctorId)
        .withConverter(
          fromFirestore: Doctor.fromFirestore,
          toFirestore: (Doctor doctor, _) => doctor.toFirestore(),
        );
    final docSnap = await ref.get();
    doctor = docSnap.data()!;
    setState(() {});
  }

  void getPatientInfo() async {
    final ref = FirebaseFirestore.instance
        .collection("patient")
        .doc(widget.patientId)
        .withConverter(
          fromFirestore: Patient.fromFirestore,
          toFirestore: (Patient patient, _) => patient.toFirestore(),
        );
    final docSnap = await ref.get();
    patient = docSnap.data()!;
    setState(() {});
  }

  Future<void> sendMessage() async {
    if (textController.text.isNotEmpty) {
      final messageDoc = FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.appointmentId)
          .collection('chat')
          .doc();

      Message message = Message(
          id: messageDoc.id,
          senderId: widget.doctorId,
          receiverId: widget.patientId,
          content: textController.text,
          sentTime: DateTime.now(),
          messageType: MessageType.text);
      final json = message.toJson();

      await messageDoc.set(json);
      setState(() {});
    }
    textController.clear();
    // ignore: use_build_context_synchronously
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    getAppointmentInfo();
    getDoctortInfo();
    getPatientInfo();
    super.initState();
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      Uint8List webImage = await image.readAsBytes();
      final messageDoc = FirebaseFirestore.instance
          .collection('appointment')
          .doc(widget.appointmentId)
          .collection('chat')
          .doc();

      Message message = Message(
          id: messageDoc.id,
          senderId: widget.doctorId,
          receiverId: widget.patientId,
          content: '',
          sentTime: DateTime.now(),
          messageType: MessageType.image);
      final json = message.toJson();

      await messageDoc.set(json);
      uploadImage(message.id, webImage);
    }
  }

  Future<void> uploadImage(String messageId, Uint8List webImage) async {
    final firebaseStorage = FirebaseStorage.instance;
    var snapshot =
        await firebaseStorage.ref().child('images/chat/$messageId').putData(
              webImage,
              SettableMetadata(contentType: 'image/jpeg'),
            );

    var downloadUrl = await snapshot.ref.getDownloadURL();

    saveImageToDatabase(messageId, downloadUrl);
  }

  saveImageToDatabase(String messageId, String url) async {
    final collection = FirebaseFirestore.instance
        .collection('appointment')
        .doc(widget.appointmentId)
        .collection('chat');

    await collection.doc(messageId).update({"content": url});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: customColor[70],
          title: Text(
            "Chat",
            style: appstyle(
              25,
              Colors.black,
              FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: appointment == null || doctor == null || patient == null
            ? Container()
            : Column(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: customColor[80],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 7.5),
                        Stack(
                          children: [
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  color: Colors.grey.shade200,
                                  child: patient!.image == ''
                                      ? const Icon(
                                          Icons.person,
                                          size: 30,
                                        )
                                      : Image.network(patient!.image,
                                          fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 1,
                              right: 1,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      30,
                                    ),
                                    color: patient!.isOnline
                                        ? Colors.green
                                        : Colors.grey),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 7.5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${patient!.firstname} ${patient!.lastname}',
                              style:
                                  appstyle(18, Colors.black, FontWeight.bold),
                            ),
                            Text(
                              patient!.isOnline
                                  ? 'Active'
                                  : 'Active ${timeago.format(patient!.lastActive, locale: 'en_short')} ago',
                              style: appstyle(
                                11,
                                patient!.isOnline
                                    ? Colors.green
                                    : Colors.black87,
                                FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: const Icon(
                        //     FontAwesomeIcons.phone,
                        //     size: 20,
                        //     color: customColor,
                        //   ),
                        // ),
                        const SizedBox(width: 7.5),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('appointment')
                          .doc(widget.appointmentId)
                          .collection('chat')
                          .orderBy('sentTime', descending: true)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        messages = snapshot.data!.docs
                            .map((doc) => Message.fromJson(doc.data()))
                            .toList();
                        return ListView.builder(
                          itemCount: messages!.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment:
                                  messages![index].senderId == widget.doctorId
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 5,
                                  right: 10,
                                  left: 10,
                                  bottom: 5,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: messages![index].senderId ==
                                          widget.doctorId
                                      ? customColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(30),
                                    topRight: const Radius.circular(30),
                                    bottomLeft: Radius.circular(
                                      messages![index].senderId ==
                                              widget.doctorId
                                          ? 30
                                          : 0,
                                    ),
                                    bottomRight: Radius.circular(
                                      messages![index].senderId !=
                                              widget.doctorId
                                          ? 30
                                          : 0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      messages![index].senderId ==
                                              widget.doctorId
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    messages![index].messageType ==
                                            MessageType.text
                                        ? Text(
                                            messages![index].content,
                                            style: appstyle(13, Colors.black,
                                                FontWeight.normal),
                                          )
                                        : Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    messages![index].content,
                                                  ),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                    const SizedBox(height: 3),
                                    Text(
                                      timeago.format(messages![index].sentTime),
                                      style: appstyle(
                                        9,
                                        Colors.black,
                                        FontWeight.normal,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await pickImage();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.image,
                            size: 20,
                            color: customColor,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            child: TextFormField(
                              controller: textController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                return null;
                              },
                              textInputAction: TextInputAction.go,
                              onFieldSubmitted: (value) async {
                                await sendMessage();
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide.none,
                                ),
                                errorStyle:
                                    appstyle(0, Colors.red, FontWeight.normal),
                                filled: true,
                                hintText: 'Message',
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10.0),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await sendMessage();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.circleArrowRight,
                            size: 20,
                            color: customColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
