import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

Diagnosis diagnosisFromJson(String str) => Diagnosis.fromJson(json.decode(str));

String diagnsosToJson(Diagnosis data) => json.encode(data.toJson());

class Diagnosis {
  final String id;
  final String domain1;
  final String domain2;
  final String domain3;
  final String domain4;
  final String problem;
  final String statement;
  final DateTime date;
  Diagnosis({
    required this.id,
    required this.domain1,
    required this.domain2,
    required this.domain3,
    required this.domain4,
    required this.problem,
    required this.statement,
    required this.date,
  });

  factory Diagnosis.fromJson(Map<String, dynamic> json) => Diagnosis(
        id: json["id"],
        domain1: json["domain1"],
        domain2: json["domain2"],
        domain3: json["domain3"],
        domain4: json["domain4"],
        problem: json["problem"],
        statement: json["statement"],
        date: json["date"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "domain1": domain1,
        "domain2": domain2,
        "domain3": domain3,
        "domain4": domain4,
        "problem": problem,
        "statement": statement,
        "date": date,
      };

  factory Diagnosis.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Diagnosis(
      id: data?["id"],
      domain1: data?["domain1"],
      domain2: data?["domain2"],
      domain3: data?["domain3"],
      domain4: data?["domain4"],
      problem: data?["problem"],
      statement: data?["statement"],
      date: data?["date"].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "domain1": domain1,
      "domain2": domain2,
      "domain3": domain3,
      "domain4": domain4,
      "problem": problem,
      "statement": statement,
      "date": date,
    };
  }
}
