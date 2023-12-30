import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  final String id;
  final bool isPatient;
  final String text;
  final DateTime date;
  Comment({
    required this.id,
    required this.isPatient,
    required this.text,
    required this.date,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        isPatient: json["isPatient"],
        text: json["text"],
        date: json["date"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isPatient": isPatient,
        "text": text,
        "date": date,
      };

  factory Comment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Comment(
      id: data?["id"],
      isPatient: data?["isPatient"],
      text: data?["text"],
      date: data?["date"].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "isPatient": isPatient,
      "text": text,
      "date": date,
    };
  }
}
