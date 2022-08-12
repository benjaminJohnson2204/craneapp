import 'package:craneapp/services/questions.dart';
import 'package:flutter/material.dart';

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
  final QuestionsService questionsService = QuestionsService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Question>(
      future: questionsService.getQuestionById(
          context: context, id: widget.questionId),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: GlobalVariables.backgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(snapshot.data!.text),
                    Container(
                        padding: const EdgeInsets.all(8),
                        color: GlobalVariables.backgroundColor,
                        child: LogoutButtonWidget()),
                    const HomeButtonWidget(),
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: snapshot.data!.options.length,
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                                onPressed: () {},
                                child:
                                    Text(snapshot.data!.options[index].text));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
