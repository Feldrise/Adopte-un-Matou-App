import 'package:flutter/foundation.dart';

enum ApplicationFieldTypes { downloaded, title, radio, text }

@immutable 
class ApplicationQuestion {
  final String id;
  final ApplicationFieldTypes type;
  final String question;
  final dynamic attributes;
  final bool mandatory;
  final dynamic value;

  const ApplicationQuestion({
    required this.id,
    required this.type,
    required this.question,
    this.attributes,
    this.mandatory = false,
    this.value,
  });

  ApplicationQuestion copyWith({
    String? id,
    ApplicationFieldTypes? type,
    String? question,
    dynamic attributes,
    bool? mandatory,
    dynamic value
  }) {
    return ApplicationQuestion(
      id: id ?? this.id,
      type: type ?? this.type,
      question: question ?? this.question,
      attributes: attributes ?? this.attributes,
      mandatory: mandatory ?? this.mandatory,
      value: value ?? this.value,
    );
  }
  
  ApplicationQuestion.fromMap(Map<String, dynamic> map):
    id = map['questionId'] as String? ?? "Unknown",
    type = ApplicationFieldTypes.downloaded,
    question = "Downloaded",
    value = map['value'] as String?,
    attributes = null,
    mandatory = false;

  Map<String, dynamic> toJson() {
    String stringValue = value.toString();
    
    return <String, dynamic>{
      "questionId": id,
      "value": stringValue
    };
  }
}



@immutable
class Application {
  final String? id;

  final String userId;
  final String catId;

  final DateTime date;
  final String step;

  final String phone;
  final String address;
  final String adultsNumber;
  final String adultsAge;
  final String childrenNumber;
  final String childrenAge;

  final Map<String, ApplicationQuestion> questions;

  const Application(this.id, {
    required this.userId,
    required this.catId,
    required this.date,
    required this.step,
    required this.phone,
    required this.address,
    required this.adultsNumber,
    required this.adultsAge,
    required this.childrenNumber,
    required this.childrenAge,
    required this.questions,
  });

  Application copyWith({
    String? id,
    String? userId,
    String? catId,
    DateTime? date,
    String? step,
    String? phone,
    String? address,
    String? adultsNumber,
    String? adultsAge,
    String? childrenNumber,
    String? childrenAge,
    Map<String, ApplicationQuestion>? questions,
    int? q1,
    int? q2,
  }) {
    return Application(
      id ?? this.id,
      userId: userId ?? this.userId,
      catId: catId ?? this.catId,
      date: date ?? this.date,
      step: step ?? this.step,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      adultsNumber: adultsNumber ?? this.adultsNumber,
      adultsAge: adultsAge ?? this.adultsAge,
      childrenNumber: childrenNumber ?? this.childrenNumber,
      childrenAge: childrenAge ?? this.childrenAge,
      questions: questions ?? this.questions,
    );
  }

  Application.fromMap(Map<String, dynamic> map) : 
    id = map['id'] as String,
    userId = map['userId'] as String? ?? "Unkown",
    catId = map['catId'] as String? ?? "Unknown",
    date = DateTime.tryParse(map['date'] as String? ?? "Unknown") ?? DateTime.now(),
    step = map['currentStep'] as String? ?? "Unknwown",
    phone = map['phoneNumber'] as String? ?? "Unknown",
    address = map['address'] as String? ?? "Unknown",
    adultsNumber = map['adultsNumber'] as String? ?? "Unknown",
    adultsAge = map['adultsAge'] as String? ?? "Unknown",
    childrenNumber = map['childrenNumber'] as String? ?? "Unknwon",
    childrenAge = map['childrenAge'] as String? ?? "Unknown",
    questions = {} {
      final List<Map<String, dynamic>> questionsList = (map['question'] as List<dynamic>? ?? <dynamic>[]).cast();

      for (final questionMap in questionsList) {
        questions[questionMap['id'] as String? ?? "Unknown"] = ApplicationQuestion.fromMap(questionMap);
      }
    }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> questionsList = [];

    for (final question in questions.values) {
      questionsList.add(question.toJson());
    }

    return <String, dynamic>{
      "id": id,
      "userId": userId,
      "catId": catId,
      "date": date.toIso8601String(),
      "applicationStep": step,
      "address": address,
      "phoneNumber": phone,
      "adultsNumber": adultsNumber,
      "adultsAge": adultsAge,
      "childrenNumber": childrenNumber,
      "childrenAge": childrenAge,
      "questions": questionsList
    };
  }
}