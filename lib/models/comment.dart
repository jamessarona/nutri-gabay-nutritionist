import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  final String id;
  final bool isPatient;
  final String text;
  final DateTime date;
  final bool isSeen;
  Comment({
    required this.id,
    required this.isPatient,
    required this.text,
    required this.date,
    required this.isSeen,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        isPatient: json["isPatient"],
        text: json["text"],
        date: json["date"].toDate(),
        isSeen: json["isSeen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isPatient": isPatient,
        "text": text,
        "date": date,
        "isSeen": isSeen,
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
      isSeen: data?["isSeen"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "isPatient": isPatient,
      "text": text,
      "date": date,
      "isSeen": isSeen,
    };
  }
}
