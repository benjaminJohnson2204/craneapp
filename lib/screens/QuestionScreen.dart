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
  int _bottomNavbarSelectedIndex = 0;

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
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          snapshot.data!.text,
                          textScaleFactor: 2,
                          textAlign: TextAlign.center,
                        ),
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
                                    ignoring: _revealOptions![index],
                                    child: ElevatedButton(
                                        onPressed: () {
                                          // Reveal the selected option
                                          setState(() {
                                            _revealOptions![index] = true;
                                          });
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
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Theme(
              data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
              child: BottomNavigationBar(
                  items: [
                    widget.questionIndex > 0
                        ? const BottomNavigationBarItem(
                            icon: Icon(Icons.arrow_back), label: "Previous")
                        : const BottomNavigationBarItem(
                            icon: Icon(null), label: ""),
                    widget.questionIndex + 1 <
                            questionsService.getQuestionCountUnderCategory(
                                context: context, category: widget.category)
                        ? const BottomNavigationBarItem(
                            icon: Icon(Icons.arrow_forward), label: "Next")
                        : const BottomNavigationBarItem(
                            icon: Icon(null), label: "")
                  ],
                  selectedItemColor: GlobalVariables.bottomNavbarTextColor,
                  unselectedItemColor: GlobalVariables.bottomNavbarTextColor,
                  onTap: (int index) {
                    if (index == 0 && widget.questionIndex > 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuestionScreen(
                              category: widget.category,
                              questionIndex: widget.questionIndex - 1),
                        ),
                      );
                    } else if (index == 1 &&
                        widget.questionIndex + 1 <
                            questionsService.getQuestionCountUnderCategory(
                                context: context, category: widget.category)) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuestionScreen(
                              category: widget.category,
                              questionIndex: widget.questionIndex + 1),
                        ),
                      );
                    }
                  }),
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
