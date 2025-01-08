import 'dart:convert';

import 'package:quizzy_ai/modals/question_modal.dart';

// Simulate an API call
Future<Quiz> fetchQuizData() async {
  // Simulating a delay as if it's an API call
  await Future.delayed(Duration(seconds: 2));

  // Mock JSON response as a string
  String jsonResponse = '''
  {
    "topic": "Dart Programming",
    "number": 2,
    "level": "easy",
    "questions": [
      {
        "question": "Which data type is used to represent a whole number in Dart?",
        "options": [
          "Option1: Integer",
          "Option2: Float",
          "Option3: String",
          "Option4: Boolean"
        ],
        "correct": "Integer",
        "explanation": "Integer is used to represent whole numbers in Dart."
      },
      {
        "question": "Question 2: What is the keyword used to create a class in Dart?",
        "options": [
          "Option1: class",
          "Option2: struct",
          "Option3: object",
          "Option4: function"
        ],
        "correct": "class",
        "explanation": "The 'class' keyword is used to define a class in Dart."
      }
    ]
  }
  ''';

  // Parse the JSON response and return Quiz object
  Map<String, dynamic> jsonData = json.decode(jsonResponse);
  return Quiz.fromJson(jsonData);
}
