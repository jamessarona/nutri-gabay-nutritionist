import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_gabay_nutritionist/models/appointment.dart';
import 'package:nutri_gabay_nutritionist/models/doctor.dart';
import 'package:nutri_gabay_nutritionist/models/patient.dart';
import 'package:nutri_gabay_nutritionist/models/patient_nutrition.dart';
import 'package:nutri_gabay_nutritionist/services/baseauth.dart';
import 'package:nutri_gabay_nutritionist/views/shared/app_style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  late Size screenSize;
  final CalendarController _calendarController = CalendarController();
  String uid = '';
  List<QueryDocumentSnapshot<Patient>>? patients;
  List<QueryDocumentSnapshot<PatientNutrition>>? patientNutritions;
  List<QueryDocumentSnapshot<Doctor>>? doctors;
  List<QueryDocumentSnapshot<Appointments>>? appointments;

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

  Future<void> getPatientNutritions() async {
    final docRef = FirebaseFirestore.instance
        .collection("patient_nutritional_profile")
        .withConverter(
          fromFirestore: PatientNutrition.fromFirestore,
          toFirestore: (PatientNutrition ptn, _) => ptn.toFirestore(),
        );
    await docRef.get().then(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          patientNutritions = querySnapshot.docs;
          setState(() {});
        }
      },
    );
  }

  Future<void> getPendingAppointments() async {
    if (uid != '') {
      final docRef = FirebaseFirestore.instance
          .collection("appointment")
          .where(
            Filter.and(Filter("status", isEqualTo: "Pending"),
                Filter("doctorId", isEqualTo: uid)),
          )
          .withConverter(
            fromFirestore: Appointments.fromFirestore,
            toFirestore: (Appointments ptn, _) => ptn.toFirestore(),
          );
      await docRef.get().then(
        (querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            appointments = querySnapshot.docs;
          }
        },
      );
    }
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

  String getPatientNutritionInfoByField(
      String patientNutritionalId, String field) {
    String result = '';
    if (patientNutritions != null) {
      for (var patientNutrition in patientNutritions!) {
        if (patientNutritionalId == patientNutrition.data().uid) {
          if (field == 'age') {
            result = patientNutrition.data().age.toStringAsFixed(0);
          } else if (field == 'birthdate') {
            result = patientNutrition.data().birthdate;
          } else if (field == 'bmi') {
            result = patientNutrition.data().bmi.toStringAsFixed(2);
          } else if (field == 'category') {
            result = patientNutrition.data().category.toString();
          } else if (field == 'date') {
            result = patientNutrition.data().date;
          } else if (field == 'height') {
            result = patientNutrition.data().height.toStringAsFixed(2);
          } else if (field == 'points') {
            result = patientNutrition.data().points.toStringAsFixed(0);
          } else if (field == 'result') {
            result = patientNutrition.data().result;
          } else if (field == 'sex') {
            result = patientNutrition.data().sex;
          } else if (field == 'status') {
            result = patientNutrition.data().status;
          } else if (field == 'weight') {
            result = patientNutrition.data().weight.toStringAsFixed(2);
          }
        }
      }
    }
    return result;
  }

  String getScheduleRange(int hourStart, int hourEnd) {
    String result = '';

    if (hourStart > 12) {
      result = '${hourStart - 12} - ${hourEnd - 12} PM';
    } else if (hourEnd < 13) {
      result = '$hourStart - $hourEnd AM';
    } else {
      result = '$hourStart AM - $hourEnd PM';
    }
    return result;
  }

  showAlertDialog(BuildContext context, String appointmentId, bool isAccept) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: appstyle(14, Colors.black, FontWeight.normal),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        !isAccept ? "Reject" : "Accept",
        style: appstyle(
            14, !isAccept ? Colors.red : Colors.green, FontWeight.bold),
      ),
      onPressed: () async {
        await updateAppointmentRequest(
                appointmentId, !isAccept ? 'Rejected' : 'Accepted')
            .whenComplete(() {
          Navigator.of(context).pop();
          setState(() {});
        });
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirmation",
        style: appstyle(15, Colors.black, FontWeight.bold),
      ),
      content: Text(
        "Are you sure you want to ${!isAccept ? "reject" : "accept"} this request?",
        style: appstyle(13, Colors.black, FontWeight.normal),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> updateAppointmentRequest(
      String appointmentId, String status) async {
    final docUser =
        FirebaseFirestore.instance.collection('appointment').doc(appointmentId);
    await docUser.update({"status": status});
  }

  Widget buildAppointmentRequest() {
    return Container(
      height: 800,
      width: screenSize.width > 500 ? screenSize.width * 0.4 : double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      // ignore: unnecessary_null_comparison
      child: uid != ''
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointment')
                  .where(
                    Filter.and(Filter("status", isEqualTo: "Pending"),
                        Filter("doctorId", isEqualTo: uid)),
                  )
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
                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return Container(
                          margin:
                              const EdgeInsets.only(top: 5, left: 5, right: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 0.4,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Container(
                                        color: Colors.grey.shade300,
                                        child: Image.network(
                                          getPatientInfoByField(
                                              data['patientId'], 'image'),
                                          fit: BoxFit.fill,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                                color: Colors.grey.shade200);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        RichText(
                                          maxLines: 2,
                                          text: TextSpan(
                                            text: getPatientInfoByField(
                                                data['patientId'], 'name'),
                                            style: appstyle(15, Colors.black,
                                                FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    ' request you appointment in ${data['dateSchedule']}',
                                                style: appstyle(
                                                    14,
                                                    Colors.black,
                                                    FontWeight.normal),
                                              ),
                                              TextSpan(
                                                text:
                                                    ' at ${getScheduleRange(data['hourStart'], data['hourEnd'])}',
                                                style: appstyle(
                                                    14,
                                                    Colors.black,
                                                    FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 70),
                                  RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: 'BMI: ',
                                      style: appstyle(
                                          13, customColor, FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              '${getPatientNutritionInfoByField(data['patientNutritionalId'], 'bmi')} - ',
                                          style: appstyle(13, Colors.black,
                                              FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: getPatientNutritionInfoByField(
                                              data['patientId'], 'status'),
                                          style: appstyle(
                                              13, customColor, FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 70),
                                  RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: 'Risk Level: ',
                                      style: appstyle(
                                          13, customColor, FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              '${getPatientNutritionInfoByField(data['patientId'], 'points')} - ',
                                          style: appstyle(13, Colors.black,
                                              FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: getPatientNutritionInfoByField(
                                              data['patientId'], 'result'),
                                          style: appstyle(
                                              13, customColor, FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showAlertDialog(
                                                context, data['id'], false);
                                          },
                                          child: Text(
                                            'Reject',
                                            style: appstyle(14, Colors.black,
                                                FontWeight.normal),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            showAlertDialog(
                                                context, data['id'], true);
                                          },
                                          child: Text(
                                            'Accept',
                                            style: appstyle(14, customColor,
                                                FontWeight.normal),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      })
                      .toList()
                      .cast(),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildSchedules() {
    return Container(
      height: 800,
      width: screenSize.width > 500 ? screenSize.width * 0.4 : double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 800,
            child: SfCalendar(
              controller: _calendarController,
              headerStyle:
                  const CalendarHeaderStyle(textAlign: TextAlign.center),
              view: CalendarView.month,
              dataSource: AppointmentSchedules(getAppointments()),
              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: true,
                appointmentDisplayCount: 5,
              ),
              initialSelectedDate: DateTime.now(),
            ),
          ),
        ],
      ),
    );
  }

  List<Appointment> getAppointments() {
    getPendingAppointments();
    List<Appointment> meetings = <Appointment>[];

    if (appointments != null) {
      for (var appointment in appointments!) {
        final DateTime bookingStart = DateFormat("MM/dd/yyyy hh").parse(
            "${appointment.data().dateSchedule} ${appointment.data().hourStart.toStringAsFixed(2)}");
        final DateTime bookingEnd = DateFormat("MM/dd/yyyy hh").parse(
            "${appointment.data().dateSchedule} ${appointment.data().hourEnd.toStringAsFixed(2)}");
        meetings.add(
          Appointment(
              startTime: bookingStart,
              endTime: bookingEnd,
              subject: appointment.data().notes,
              color: customColor),
        );
      }
    }
    return meetings;
  }

  @override
  void initState() {
    getNutritionistId();
    getPatients();
    getPatientNutritions();
    getPendingAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Container(
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
              'Appointment Request',
              style: appstyle(
                25,
                Colors.black,
                FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: screenSize.width > 500
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildAppointmentRequest(),
                      buildSchedules(),
                    ],
                  )
                : ListView(
                    children: [
                      buildAppointmentRequest(),
                      buildSchedules(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class AppointmentSchedules extends CalendarDataSource {
  AppointmentSchedules(List<Appointment> source) {
    appointments = source;
  }
}
