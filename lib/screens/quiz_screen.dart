import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quizzy_ai/modals/question_modal.dart';
import 'package:quizzy_ai/fetch_quiz_datas.dart';
import 'package:quizzy_ai/screens/quiz_answer_details_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<Quiz> quizData;
  int currentQuestionIndex = 0;
  String? selectedOption;
  bool showExplanation = false;

  @override
  void initState() {
    super.initState();
    quizData = fetchQuizData();
    Hive.openBox('userAnswers'); // Open the userAnswers Hive box
  }

  void checkAnswer(String selected, String correct) async {
    setState(() {
      selectedOption = selected;
      showExplanation = true;

      if (selected == correct) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Correct! Well done!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect. Try better next time!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    // Save the selected answer in Hive
    final box = Hive.box('userAnswers');
    final questionKey = 'question_${currentQuestionIndex + 1}';
    await box.put(questionKey, {
      'selectedAnswer': selected,
      'isCorrect': selected == correct,
    });
  }

  void nextQuestion(Quiz quiz) {
    setState(() {
      if (currentQuestionIndex < quiz.questions.length - 1) {
        currentQuestionIndex++;
        selectedOption = null;
        showExplanation = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have completed the quiz!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: FutureBuilder<Quiz>(
        future: quizData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            Quiz quiz = snapshot.data!;
            Question question = quiz.questions[currentQuestionIndex];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question ${currentQuestionIndex + 1} of ${quiz.questions.length}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    question.question,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  ...question.options.map((option) {
                    String optionValue = option.split(": ")[1];
                    bool isCorrect = optionValue == question.correct;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedOption == optionValue
                              ? (isCorrect ? Colors.green : Colors.red)
                              : Colors.grey,
                        ),
                        onPressed: showExplanation
                            ? null
                            : () => checkAnswer(optionValue, question.correct),
                        child: Text(optionValue),
                      ),
                    );
                  }),
                  if (showExplanation) ...[
                    SizedBox(height: 20),
                    Text("Explanation:"),
                    Text(
                      question.explanation,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  Spacer(),
                  if (currentQuestionIndex < quiz.questions.length - 1)
                    ElevatedButton(
                      onPressed:
                          showExplanation ? () => nextQuestion(quiz) : null,
                      child: Text('Next'),
                    )
                  else
                    ElevatedButton(
                      onPressed: () async {
                        final box = Hive.box('dartQuestions');
                        final userBox = Hive.box('userAnswers');

                        // Prepare quiz data
                        final quizData = quiz.questions.map((question) {
                          return {
                            'question': question.question,
                            'correctAnswer': question.correct,
                            'explanation': question.explanation,
                            'options': question.options,
                          };
                        }).toList();

                        await box.put('quizData', quizData);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Quiz details saved in Hive!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return QuizAnswerDetailsScreen();
                        }));
                      },
                      child: Text('Show Question Details'),
                    ),
                ],
              ),
            );
          }

          return Center(child: Text('No data available.'));
        },
      ),
    );
  }
}
