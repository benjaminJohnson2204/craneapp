import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/category.dart';
import 'package:craneapp/models/question.dart';
import 'package:craneapp/screens/LoginScreen.dart';
import 'package:craneapp/services/categories.dart';
import 'package:craneapp/services/checkAuthenticated.dart';
import 'package:craneapp/services/logout.dart';
import 'package:craneapp/services/questions.dart';
import 'package:craneapp/widgets/category_selector.dart';
import 'package:craneapp/widgets/home_button.dart';
import 'package:craneapp/widgets/logout_button.dart';
import 'package:craneapp/widgets/question_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/questionPreview.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = "/category";
  final Category category;
  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<dynamic> _questions = [];
  final CheckAuthenticatedService authenticatedService =
      CheckAuthenticatedService();
  final QuestionsService questionsService = QuestionsService();

  @override
  void initState() {
    super.initState();
    questionsService
        .getQuestionsUnderCategory(context: context, id: widget.category.id)
        .then((List<dynamic> questions) {
      setState(() {
        _questions = questions;
      });
    });
  }

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
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return QuestionSelectorWidget(
                          index: index,
                          text: _questions[index].text,
                          id: _questions[index].id);
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
