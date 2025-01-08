// return ListView.builder(
// itemCount: quiz.questions.length,
// itemBuilder: (context, index) {
// Question question = quiz.questions[index];
// return Card(
// child: ListTile(
// title: Text(question.question),
// subtitle: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// ...question.options.map((option) => Text(option)),
// SizedBox(height: 10),
// Text('Explanation: ${question.explanation}'),
// ],
// ),
// ),
// );
// },
// );