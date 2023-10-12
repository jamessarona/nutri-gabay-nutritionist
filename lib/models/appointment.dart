import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Appointment appointmentFromJson(String str) =>
    Appointment.fromJson(json.decode(str));

String appointmentToJson(Appointment data) => json.encode(data.toJson());

class Appointment {
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

  Appointment({
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

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
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

  factory Appointment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Appointment(
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
