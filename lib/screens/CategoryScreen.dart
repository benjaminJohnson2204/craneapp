import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/category.dart';
import 'package:craneapp/services/checkAuthenticated.dart';
import 'package:craneapp/services/questions.dart';
import 'package:craneapp/widgets/home_button.dart';
import 'package:craneapp/widgets/logout_button.dart';
import 'package:craneapp/widgets/question_selector.dart';
import 'package:flutter/material.dart';

import '../models/questionPreview.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = "/category";
  final Category category;
  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CheckAuthenticatedService authenticatedService =
      CheckAuthenticatedService();
  final QuestionsService questionsService = QuestionsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.category.name),
              Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: LogoutButtonWidget()),
              const HomeButtonWidget(),
              FutureBuilder<List<QuestionPreview>>(
                future: questionsService.getQuestionsUnderCategory(
                    context: context, id: widget.category.id),
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
                                id: snapshot.data![index].id);
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
