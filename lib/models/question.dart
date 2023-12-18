import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Question questionFromJson(String str) => Question.fromJson(json.decode(str));

String questionToJson(Question data) => json.encode(data.toJson());

class Question {
  final String uid;
  final String formId;
  final int number;
  final String question;
  final String type;
  final bool required;
  final String answer;

  Question({
    required this.uid,
    required this.formId,
    required this.number,
    required this.question,
    required this.type,
    required this.required,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        uid: json["uid"],
        formId: json["formId"],
        number: json["number"],
        question: json["question"],
        type: json["type"],
        required: json["required"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "formId": formId,
        "number": number,
        "question": question,
        "type": type,
        "required": required,
        "answer": answer,
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
      question: data?["question"],
      type: data?["type"],
      required: data?["required"],
      answer: data?["answer"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "formId": formId,
      "number": number,
      "question": question,
      "type": type,
      "required": required,
      "answer": answer,
    };
  }
}
