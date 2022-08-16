import 'package:craneapp/screens/QuestionScreen.dart';
import 'package:flutter/material.dart';

class QuestionSelectorWidget extends StatelessWidget {
  final int index;
  final String text;
  final String category;
  const QuestionSelectorWidget(
      {Key? key,
      required this.index,
      required this.text,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => QuestionScreen(
                      category: category, questionIndex: index)));
        },
        child: Text("${index + 1} $text"));
  }
}
