import 'package:craneapp/screens/question_screen.dart';
import 'package:flutter/material.dart';

class QuestionSelectorWidget extends StatelessWidget {
  final int index;
  final String text;
  final String category;
  final Color color;
  const QuestionSelectorWidget(
      {Key? key,
      required this.index,
      required this.text,
      required this.category,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    QuestionScreen(category: category, questionIndex: index)));
      },
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
      child: Text("${index + 1}"),
    );
  }
}
