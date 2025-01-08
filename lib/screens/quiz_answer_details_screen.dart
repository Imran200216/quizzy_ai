import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class QuizAnswerDetailsScreen extends StatelessWidget {
  const QuizAnswerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Open the Hive box
    final box = Hive.box('dartQuestions');
    final quizData = box.get('quizData');
    final userAnswersBox = Hive.box('userAnswers');

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Answer Details'),
      ),
      body: quizData == null || quizData.isEmpty
          ? Center(
              child: Text(
                'No data available.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: quizData.length,
              itemBuilder: (context, index) {
                final questionData = quizData[index];
                final options = questionData['options'] as List;

                /// for taking user answers
                // Retrieve user-selected answer
                final questionKey = 'question_${index + 1}';
                final userAnswer = userAnswersBox.get(questionKey);
                final userSelectedAnswer =
                    userAnswer?['selectedAnswer'] ?? 'N/A';
                final isCorrect = userAnswer?['isCorrect'] ?? false;

                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q${index + 1}: ${questionData['question']}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Options:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ...options.map((option) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                option,
                                style: TextStyle(fontSize: 16),
                              ),
                            )),
                        SizedBox(height: 10),
                        Text(
                          'Correct Answer: ${questionData['correctAnswer']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Explanation:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          questionData['explanation'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),

                        /// user choose answer title
                        Text(
                          'User choose answer:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        /// user choose answer
                        Text(
                          userSelectedAnswer,
                          style: TextStyle(
                            fontSize: 16,
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
