// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

QuizTrackModel welcomeFromJson(String str) =>
    QuizTrackModel.fromJson(json.decode(str));

String welcomeToJson(QuizTrackModel data) => json.encode(data.toJson());

class QuizTrackModel {
  QuizTrackModel({
    this.quizdata,
    this.date,
    this.quizlevel,
    this.courseName,
    this.courseId,
    this.quizCleared,
    this.quizAttemptGapForModularQuiz,
    this.quizAttemptGapForCourseQuiz,
    this.quizname,
    this.quizScore,
  });

  List<dynamic>? quizdata;
  DateTime? date;
  String? quizlevel;
  String? courseName;
  String? courseId;
  bool? quizCleared;
  DateTime? quizAttemptGapForModularQuiz;
  DateTime? quizAttemptGapForCourseQuiz;
  String? quizname;
  num? quizScore;

  factory QuizTrackModel.fromJson(Map<String, dynamic> json) => QuizTrackModel(
        quizdata: json["quizdata"] == null
            ? []
            : List<dynamic>.from(json["quizdata"]!.map((x) => x)),
        date: (json["date"] as Timestamp).toDate(),
        quizlevel: json["quizlevel"],
        courseName: json["courseName"],
        courseId: json["courseId"],
        quizCleared: json["quizCleared"],
        quizAttemptGapForModularQuiz:
            (json["quizAttemptGapForModularQuiz"] as Timestamp).toDate(),
        quizAttemptGapForCourseQuiz:
            (json["quizAttemptGapForCourseQuiz"] as Timestamp).toDate(),
        quizname: json["quizname"],
        quizScore: json["quizScore"],
      );

  Map<String, dynamic> toJson() => {
        "quizdata":
            quizdata == null ? [] : List<dynamic>.from(quizdata!.map((x) => x)),
        "date": date,
        "quizlevel": quizlevel,
        "courseName": courseName,
        "courseId": courseId,
        "quizCleared": quizCleared,
        "quizAttemptGapForModularQuiz": quizAttemptGapForModularQuiz,
        "quizAttemptGapForCourseQuiz": quizAttemptGapForCourseQuiz,
        "quizname": quizname,
        "quizScore": quizScore,
      };

  toMap() {}
}
