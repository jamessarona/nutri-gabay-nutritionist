import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

FormQuestion formQuestionsFromJson(String str) =>
    FormQuestion.fromJson(json.decode(str));

String formQuestionsToJson(FormQuestion data) => json.encode(data.toJson());

class FormQuestion {
  final String id;
  final String name;
  final DateTime date;
  final bool answered;
  final bool isSeen;
  FormQuestion({
    required this.id,
    required this.name,
    required this.date,
    required this.answered,
    required this.isSeen,
  });

  factory FormQuestion.fromJson(Map<String, dynamic> json) => FormQuestion(
        id: json["id"],
        name: json["name"],
        date: json["date"].toDate(),
        answered: json["answered"],
        isSeen: json["isSeen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date": date,
        "answered": answered,
        "isSeen": isSeen,
      };

  factory FormQuestion.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return FormQuestion(
      id: data?["id"],
      name: data?["name"],
      date: data?["date"].toDate(),
      answered: data?["answered"],
      isSeen: data?["isSeen"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "date": date,
      "answered": answered,
      "isSeen": isSeen,
    };
  }
}
