import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:quizzy_ai/screens/quiz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// hive db set up
  await Hive.initFlutter();

  /// hive box name or db name
  await Hive.openBox('dartQuestions');

  /// hive box user answers
  await Hive.openBox('userAnswered');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: QuizScreen(),
    );
  }
}
