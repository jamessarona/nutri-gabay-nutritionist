import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PatientNutrition patientNutritionFromJson(String str) =>
    PatientNutrition.fromJson(json.decode(str));

String patientNutritionToJson(PatientNutrition data) =>
    json.encode(data.toJson());

class PatientNutrition {
  final String id;
  final String uid;
  final double height;
  final double weight;
  final String birthdate;
  final String date;
  final int age;
  final String sex;
  final double bmi;
  final int category;
  final String status;
  final double points;
  final String result;

  PatientNutrition({
    required this.id,
    required this.uid,
    required this.height,
    required this.weight,
    required this.date,
    required this.birthdate,
    required this.age,
    required this.sex,
    required this.bmi,
    required this.category,
    required this.status,
    required this.points,
    required this.result,
  });

  factory PatientNutrition.fromJson(Map<String, dynamic> json) =>
      PatientNutrition(
        id: json["id"],
        uid: json["uid"],
        height: json["height"],
        weight: json["weight"],
        date: json["date"],
        birthdate: json["birthdate"],
        age: json["age"],
        sex: json["sex"],
        bmi: json["bmi"],
        category: json["category"],
        status: json["status"],
        points: json["points"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "height": height,
        "weight": weight,
        "date": date,
        "birthdate": birthdate,
        "age": age,
        "sex": sex,
        "bmi": bmi,
        "category": category,
        "status": status,
        "points": points,
        "result": result,
      };

  factory PatientNutrition.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return PatientNutrition(
      id: data?["id"],
      uid: data?["uid"],
      height: data?["height"],
      weight: data?["weight"],
      date: data?["date"],
      birthdate: data?["birthdate"],
      age: data?["age"],
      sex: data?["sex"],
      bmi: data?["bmi"],
      category: data?["category"],
      status: data?["status"],
      points: data?["points"],
      result: data?["result"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "uid": uid,
      "height": height,
      "weight": weight,
      "date": date,
      "birthdate": birthdate,
      "age": age,
      "sex": sex,
      "bmi": bmi,
      "category": category,
      "status": status,
      "points": points,
      "result": result,
    };
  }
}
