import 'package:craneapp/screens/CategoryScreen.dart';
import 'package:craneapp/services/questions.dart';
import 'package:flutter/material.dart';

import '../constants/global_variables.dart';
import '../models/question.dart';
import '../widgets/home_button.dart';
import '../widgets/logout_button.dart';

class QuestionScreen extends StatefulWidget {
  final String category;
  final int questionIndex;
  const QuestionScreen(
      {Key? key, required this.category, required this.questionIndex})
      : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final QuestionsService questionsService = QuestionsService();
  List<bool>? _revealOptions;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Question>(
      future: questionsService.getQuestionUnderCategoryByIndex(
          context: context,
          category: widget.category,
          index: widget.questionIndex),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          _revealOptions ??= snapshot.data!.selectedOptionsIndices;
          return Scaffold(
            backgroundColor: GlobalVariables.backgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const HomeButtonWidget(),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryScreen(
                                      category: snapshot.data!.category,
                                    ),
                                  ),
                                );
                              },
                              child: Text(snapshot.data!.category)),
                          LogoutButtonWidget(),
                        ]),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        snapshot.data!.text,
                        textScaleFactor: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: snapshot.data!.options.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  IgnorePointer(
                                    ignoring: snapshot
                                        .data!.selectedOptionsIndices[index],
                                    child: ElevatedButton(
                                        onPressed: () {
                                          questionsService
                                              .answerQuestion(
                                                  context: context,
                                                  category: widget.category,
                                                  questionIndex:
                                                      widget.questionIndex,
                                                  selectedOptionIndex: index)
                                              .then((isCorrect) {
                                            if (isCorrect) {
                                              // Reveal all options when correct option is chosen
                                              setState(() {
                                                _revealOptions = [
                                                  for (var option
                                                      in snapshot.data!.options)
                                                    true
                                                ];
                                              });
                                            } else {
                                              // Reveal only this option if it's incorrect
                                              setState(() {
                                                _revealOptions![index] = true;
                                              });
                                              if (_revealOptions!
                                                      .where(
                                                          (option) => !option)
                                                      .length <=
                                                  1) {
                                                // Reveal all options once all incorrect options are chosen
                                                setState(() {
                                                  _revealOptions = [
                                                    for (var option in snapshot
                                                        .data!.options)
                                                      true
                                                  ];
                                                });
                                              }
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    _revealOptions![index]
                                                        ? (snapshot
                                                                .data!
                                                                .options[index]
                                                                .isCorrect
                                                            ? Colors.green
                                                            : Colors.red)
                                                        : Colors.blue)),
                                        child: Text(snapshot
                                            .data!.options[index].text)),
                                  ),
                                  _revealOptions![index]
                                      ? Text(snapshot
                                          .data!.options[index].explanation)
                                      : const Text("")
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: IgnorePointer(
                        ignoring: !_revealOptions!.any(((element) => element)),
                        child: ElevatedButton(
                          onPressed: () {
                            questionsService
                                .resetAnswersToQuestion(
                                    context: context,
                                    category: widget.category,
                                    questionIndex: widget.questionIndex)
                                .then(
                                  (result) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuestionScreen(
                                        category: widget.category,
                                        questionIndex: widget.questionIndex,
                                      ),
                                    ),
                                  ),
                                );
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: const Text("Reset"),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IgnorePointer(
                          ignoring: widget.questionIndex == 0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QuestionScreen(
                                          category: widget.category,
                                          questionIndex:
                                              widget.questionIndex - 1)));
                            },
                            child: const Text("Previous"),
                          ),
                        ),
                        IgnorePointer(
                          ignoring: widget.questionIndex + 1 ==
                              questionsService.getQuestionCountUnderCategory(
                                  context: context, category: widget.category),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QuestionScreen(
                                          category: widget.category,
                                          questionIndex:
                                              widget.questionIndex + 1)));
                            },
                            child: const Text("Next"),
                          ),
                        ),
                      ],
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
