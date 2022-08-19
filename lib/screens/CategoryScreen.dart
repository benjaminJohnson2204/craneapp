import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/services/categories.dart';
import 'package:craneapp/services/checkAuthenticated.dart';
import 'package:craneapp/services/questions.dart';
import 'package:craneapp/widgets/home_button.dart';
import 'package:craneapp/widgets/logout_button.dart';
import 'package:craneapp/widgets/question_selector.dart';
import 'package:flutter/material.dart';

import '../models/question.dart';
import '../widgets/app_bar.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = "/category";
  final String category;
  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CheckAuthenticatedService authenticatedService =
      CheckAuthenticatedService();
  final QuestionsService questionsService = QuestionsService();
  final CategoriesService categoriesService = CategoriesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(context: context),
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<Map<String, int>>(
                future: categoriesService.getProgressOnCategory(
                    context: context, category: widget.category),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${widget.category} (${snapshot.data!["correct"]} / ${snapshot.data!["total"]})',
                        textScaleFactor: 2,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              FutureBuilder<List<Question>>(
                future: questionsService.getQuestionsUnderCategory(
                    context: context, category: widget.category),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return QuestionSelectorWidget(
                                index: index,
                                text: snapshot.data![index].text,
                                category: widget.category,
                                color: () {
                                  bool foundCorrect = false,
                                      foundSelected = false;
                                  for (int i = 0;
                                      i <
                                          snapshot.data![index]
                                              .selectedOptionsIndices.length;
                                      i++) {
                                    if (snapshot.data![index]
                                        .selectedOptionsIndices[i]) {
                                      if (snapshot
                                          .data![index].options[i].isCorrect) {
                                        foundCorrect = true;
                                      } else {
                                        foundSelected = true;
                                      }
                                    }
                                  }
                                  return foundCorrect
                                      ? Colors.green
                                      : (foundSelected
                                          ? Colors.red
                                          : Colors.blue);
                                }());
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    questionsService
                        .resetAnswersToQuestionsByCategory(
                            context: context, category: widget.category)
                        .then(
                          (result) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryScreen(category: widget.category),
                            ),
                          ),
                        );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Text("Reset"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
