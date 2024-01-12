import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Question questionFromJson(String str) => Question.fromJson(json.decode(str));

String questionToJson(Question data) => json.encode(data.toJson());

class Question {
  final String uid;
  final String formId;
  final int number;
  final String indicator;
  final String criteria;
  final String progress;
  final bool marked;
  final bool resolved;

  Question({
    required this.uid,
    required this.formId,
    required this.number,
    required this.indicator,
    required this.criteria,
    required this.progress,
    required this.marked,
    required this.resolved,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        uid: json["uid"],
        formId: json["formId"],
        number: json["number"],
        indicator: json["indicator"],
        criteria: json["criteria"],
        progress: json["progress"],
        marked: json["marked"],
        resolved: json["resolved"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "formId": formId,
        "number": number,
        "indicator": indicator,
        "criteria": criteria,
        "progress": progress,
        "marked": marked,
        "resolved": resolved,
      };

  factory Question.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Question(
      uid: data?["uid"],
      formId: data?["formId"],
      number: data?["number"],
      indicator: data?["indicator"],
      criteria: data?["criteria"],
      progress: data?["progress"],
      marked: data?["marked"],
      resolved: data?["resolved"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "formId": formId,
      "number": number,
      "indicator": indicator,
      "criteria": criteria,
      "progress": progress,
      "marked": marked,
      "resolved": resolved,
    };
  }
}
