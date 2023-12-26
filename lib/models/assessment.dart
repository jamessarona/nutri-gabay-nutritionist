import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Assessment assessmentFromJson(String str) =>
    Assessment.fromJson(json.decode(str));

String assessmentToJson(Assessment data) => json.encode(data.toJson());

class Assessment {
  final String id;
  final String history;
  final String situation;
  final String occupation;
  final String relatedHistory;
  final int change;
  final int success;
  final int start;

  final String procedures;
  final String measurements;
  final String findings;
  final String standards;
  final DateTime date;
  Assessment({
    required this.id,
    required this.history,
    required this.situation,
    required this.occupation,
    required this.relatedHistory,
    required this.change,
    required this.success,
    required this.start,
    required this.procedures,
    required this.measurements,
    required this.findings,
    required this.standards,
    required this.date,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        id: json["id"],
        history: json["history"],
        situation: json["situation"],
        occupation: json["occupation"],
        relatedHistory: json["relatedHistory"],
        change: json["change"],
        success: json["success"],
        start: json["start"],
        procedures: json["procedures"],
        measurements: json["measurements"],
        findings: json["findings"],
        standards: json["standards"],
        date: json["date"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "history": history,
        "situation": situation,
        "occupation": occupation,
        "relatedHistory": relatedHistory,
        "change": change,
        "success": success,
        "start": start,
        "procedures": procedures,
        "measurements": measurements,
        "findings": findings,
        "standards": standards,
        "date": date,
      };

  factory Assessment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Assessment(
      id: data?["id"],
      history: data?["history"],
      situation: data?["situation"],
      occupation: data?["occupation"],
      relatedHistory: data?["relatedHistory"],
      change: data?["change"],
      success: data?["success"],
      start: data?["start"],
      procedures: data?["procedures"],
      measurements: data?["measurements"],
      findings: data?["findings"],
      standards: data?["standards"],
      date: data?["date"].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "history": history,
      "situation": situation,
      "occupation": occupation,
      "relatedHistory": relatedHistory,
      "change": change,
      "success": success,
      "start": start,
      "procedures": procedures,
      "measurements": measurements,
      "findings": findings,
      "standards": standards,
      "date": date,
    };
  }
}
