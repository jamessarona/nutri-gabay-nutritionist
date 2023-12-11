import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

FormQuestion formQuestionsFromJson(String str) =>
    FormQuestion.fromJson(json.decode(str));

String formQuestionsToJson(FormQuestion data) => json.encode(data.toJson());

class FormQuestion {
  final String uid;
  final String name;
  final DateTime date;

  FormQuestion({
    required this.uid,
    required this.name,
    required this.date,
  });

  factory FormQuestion.fromJson(Map<String, dynamic> json) => FormQuestion(
        uid: json["uid"],
        name: json["name"],
        date: json["date"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "date": date,
      };

  factory FormQuestion.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return FormQuestion(
      uid: data?["uid"],
      name: data?["name"],
      date: data?["date"].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "name": name,
      "date": date,
    };
  }
}
