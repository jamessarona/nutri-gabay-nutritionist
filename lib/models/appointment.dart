import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Appointments appointmentFromJson(String str) =>
    Appointments.fromJson(json.decode(str));

String appointmentToJson(Appointments data) => json.encode(data.toJson());

class Appointments {
  final String id;
  final String dateRecorded;
  final String dateSchedule;
  final int hourStart;
  final int hourEnd;
  final String patientId;
  final String patientNutritionalId;
  final String doctorId;
  final String notes;
  final String status;

  Appointments({
    required this.id,
    required this.dateRecorded,
    required this.dateSchedule,
    required this.hourStart,
    required this.hourEnd,
    required this.patientId,
    required this.patientNutritionalId,
    required this.doctorId,
    required this.notes,
    required this.status,
  });

  factory Appointments.fromJson(Map<String, dynamic> json) => Appointments(
        id: json["id"],
        dateRecorded: json["dateRecorded"],
        dateSchedule: json["dateSchedule"],
        hourStart: json["hourStart"],
        hourEnd: json["hourEnd"],
        patientId: json["patientId"],
        patientNutritionalId: json["patientNutritionalId"],
        doctorId: json["doctorId"],
        notes: json["notes"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "dateRecorded": dateRecorded,
        "dateSchedule": dateSchedule,
        "hourStart": hourStart,
        "hourEnd": hourEnd,
        "patientId": patientId,
        "patientNutritionalId": patientNutritionalId,
        "doctorId": doctorId,
        "notes": notes,
        "status": status,
      };

  factory Appointments.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Appointments(
      id: data?["id"],
      dateRecorded: data?["dateRecorded"],
      dateSchedule: data?["dateSchedule"],
      hourStart: data?["hourStart"],
      hourEnd: data?["hourEnd"],
      patientId: data?["patientId"],
      patientNutritionalId: data?["patientNutritionalId"],
      doctorId: data?["doctorId"],
      notes: data?["notes"],
      status: data?["status"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "dateRecorded": dateRecorded,
      "dateSchedule": dateSchedule,
      "hourStart": hourStart,
      "hourEnd": hourEnd,
      "patientId": patientId,
      "patientNutritionalId": patientNutritionalId,
      "doctorId": doctorId,
      "notes": notes,
      "status": status,
    };
  }
}
