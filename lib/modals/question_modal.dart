class Question {
  final String question;
  final List<String> options;
  final String correct;
  final String explanation;

  Question({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: List<String>.from(json['options']),
      correct: json['correct'],
      explanation: json['explanation'],
    );
  }
}

class Quiz {
  final String topic;
  final int number;
  final String level;
  final List<Question> questions;

  Quiz({
    required this.topic,
    required this.number,
    required this.level,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    var questionsList = json['questions'] as List;
    List<Question> questions =
        questionsList.map((e) => Question.fromJson(e)).toList();

    return Quiz(
      topic: json['topic'],
      number: json['number'],
      level: json['level'],
      questions: questions,
    );
  }
}
