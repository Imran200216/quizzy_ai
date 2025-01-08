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
  int currentQuestionIndex = 0; // Track the current question index
  String? selectedOption; // Track the selected option
  bool showExplanation = false; // Control whether to show explanation

  @override
  void initState() {
    super.initState();
    quizData = fetchQuizData(); // Simulating API call
  }

  void checkAnswer(String selected, String correct) {
    setState(() {
      selectedOption = selected;
      showExplanation = true; // Show explanation

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
  }

  void nextQuestion(Quiz quiz) {
    setState(() {
      if (currentQuestionIndex < quiz.questions.length - 1) {
        currentQuestionIndex++;
        selectedOption = null; // Reset selection
        showExplanation = false; // Hide explanation
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
                  /// questions nos
                  Text(
                    "Question ${currentQuestionIndex + 1} of ${quiz.questions.length}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  /// questions
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

                    /// question explanation
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

                  /// next btn or show question details
                  if (currentQuestionIndex < quiz.questions.length - 1)

                    /// next btn for moving to the next screen
                    ElevatedButton(
                      onPressed:
                          showExplanation ? () => nextQuestion(quiz) : null,
                      child: Text('Next'),
                    )
                  else

                    /// show btn to showcase the question and answers
                    ElevatedButton(
                      onPressed: () async {
                        final box = Hive.box('dartQuestions');

                        // Prepare data to store in Hive
                        final quizData = quiz.questions.map((question) {
                          return {
                            'question': question.question,
                            'correctAnswer': question.correct,
                            'explanation': question.explanation,
                            'options': question.options,
                          };
                        }).toList();

                        // Store data in Hive
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
