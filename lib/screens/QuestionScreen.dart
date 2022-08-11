import 'package:craneapp/services/questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants/global_variables.dart';
import '../models/question.dart';
import '../widgets/home_button.dart';
import '../widgets/logout_button.dart';

class QuestionScreen extends StatefulWidget {
  final String questionId;
  const QuestionScreen({Key? key, required this.questionId}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  Question? _question;
  bool loading = true;
  final QuestionsService questionsService = QuestionsService();

  @override
  void initState() {
    super.initState();
    questionsService
        .getQuestionById(context: context, id: widget.questionId)
        .then((question) {
      setState(() {
        _question = question;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Text("loading...");
    }
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_question!.text),
              Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: LogoutButtonWidget()),
              const HomeButtonWidget(),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _question!.options.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                          onPressed: () {},
                          child: Text(_question!.options[index].text));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
