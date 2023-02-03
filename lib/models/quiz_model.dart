// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Quiz welcomeFromJson(String str) => Quiz.fromJson(json.decode(str));

String welcomeToJson(Quiz data) => json.encode(data.toJson());

class Quiz {
    Quiz({
        required this.module,
        required this.negativemarking,
        required this.quizMap,
        required this.quizranking,
        required this.type,
    });

    String module;
    Negativemarking negativemarking;
    QuizMap quizMap;
    String quizranking;
    String type;

    factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        module: json["module"],
        negativemarking: Negativemarking.fromJson(json["negativemarking"]),
        quizMap: QuizMap.fromJson(json["quizMap"]),
        quizranking: json["quizranking"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "module": module,
        "negativemarking": negativemarking.toJson(),
        "quizMap": quizMap.toJson(),
        "quizranking": quizranking,
        "type": type,
    };
}

class Negativemarking {
    Negativemarking({
        required this.the4,
    });

    String the4;

    factory Negativemarking.fromJson(Map<String, dynamic> json) => Negativemarking(
        the4: json["4"],
    );

    Map<String, dynamic> toJson() => {
        "4": the4,
    };
}

class QuizMap {
    QuizMap({
        required this.problembucket,
    });

    Problembucket problembucket;

    factory QuizMap.fromJson(Map<String, dynamic> json) => QuizMap(
        problembucket: Problembucket.fromJson(json["problembucket"]),
    );

    Map<String, dynamic> toJson() => {
        "problembucket": problembucket.toJson(),
    };
}

class Problembucket {
    Problembucket({
        required this.question,
        required this.answer,
        required this.answerindex,
        required this.solution,
        required this.options,
    });

    String question;
    String answer;
    String answerindex;
    String solution;
    List<String> options;

    factory Problembucket.fromJson(Map<String, dynamic> json) => Problembucket(
        question: json["question"],
        answer: json["answer"],
        answerindex: json["answerindex"],
        solution: json["solution"],
        options: List<String>.from(json["options"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
        "answerindex": answerindex,
        "solution": solution,
        "options": List<dynamic>.from(options.map((x) => x)),
    };
}
