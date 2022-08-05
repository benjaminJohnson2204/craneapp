import 'package:flutter/material.dart';

class QuestionSelectorWidget extends StatelessWidget {
  final int index;
  final VoidCallback onTap;
  const QuestionSelectorWidget(
      {Key? key, required this.index, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: this.onTap, child: Text(this.index.toString()));
  }
}
