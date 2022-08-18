import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/util.dart';
import '../models/option.dart';
import '../models/question.dart';

class QuestionsService {
  Map<String, List<Question>> questionsByCategory = {};

  Future<List<Question>> getQuestionsUnderCategory(
      {required BuildContext context, required String category}) async {
    if (questionsByCategory.containsKey(category)) {
      return questionsByCategory[category]!;
    }
    SharedPreferences prefs;
    String? token;
    try {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("x-auth-token");
    } catch (error) {
      SharedPreferences.setMockInitialValues({});
    }
    try {
      http.Response questionsRes =
          await http.get(Uri.parse('$uri/question/category/$category'));
      http.Response answersRes = await http.get(
          Uri.parse('$uri/userAnswer/category/$category'),
          headers: {"x-auth-token": token!});
      List<Question> result = [
        for (var question in jsonDecode(questionsRes.body)["questions"])
          Question(
              text: question["questionText"],
              id: question["_id"],
              options: [
                for (var option in question["options"])
                  Option(
                      text: option["text"],
                      explanation: option["explanation"],
                      isCorrect: option["isCorrect"])
              ],
              category: question["category"],
              selectedOptionsIndices: () {
                List<int> userAnswers = [];
                for (var userAnswer
                    in jsonDecode(answersRes.body)["userAnswers"]) {
                  if (userAnswer["question"] == question["_id"]) {
                    userAnswers.add(userAnswer["selectedOptionIndex"]);
                  }
                }
                List<bool> selectedOptionsIndices = [];
                for (var option in question["options"]) {
                  selectedOptionsIndices
                      .add(userAnswers.contains(option["index"]));
                }
                return selectedOptionsIndices;
              }())
      ];
      questionsByCategory.putIfAbsent(category, () => result);
      return result;
    } catch (error) {
      showSnackBar(context, error.toString());
      return [];
    }
  }

  Future<Question> getQuestionUnderCategoryByIndex(
      {required BuildContext context,
      required String category,
      required int index}) async {
    if (questionsByCategory.containsKey(category)) {
      return questionsByCategory[category]![index];
    }
    await getQuestionsUnderCategory(context: context, category: category);
    return questionsByCategory[category]![index];
  }

  int getQuestionCountUnderCategory(
      {required BuildContext context, required String category}) {
    return questionsByCategory[category]!.length;
  }

  Future<bool> answerQuestion(
      {required BuildContext context,
      required String category,
      required int questionIndex,
      required int selectedOptionIndex}) async {
    SharedPreferences prefs;
    String? token;
    try {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("x-auth-token");
    } catch (error) {
      SharedPreferences.setMockInitialValues({});
    }
    try {
      Question question = await getQuestionUnderCategoryByIndex(
          context: context, category: category, index: questionIndex);
      http.Response res = await http.post(Uri.parse('$uri/userAnswer/answer'),
          body: jsonEncode({
            "questionId": question.id,
            "selectedOptionIndex": selectedOptionIndex
          }),
          headers: {
            "Content-Type": "application/json",
            "x-auth-token": token!
          });
      return jsonDecode(res.body)["correct"];
    } catch (error) {
      showSnackBar(context, error.toString());
      return false;
    }
  }

  Future<void> resetAnswersToQuestion(
      {required BuildContext context,
      required String category,
      required int questionIndex}) async {
    SharedPreferences prefs;
    String? token;
    try {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("x-auth-token");
    } catch (error) {
      SharedPreferences.setMockInitialValues({});
    }
    try {
      Question question = await getQuestionUnderCategoryByIndex(
          context: context, category: category, index: questionIndex);
      await http.post(
          Uri.parse('$uri/userAnswer/reset/question/${question.id}'),
          headers: {"x-auth-token": token!});
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  Future<void> resetAnswersToQuestionsByCategory(
      {required BuildContext context, required String category}) async {
    SharedPreferences prefs;
    String? token;
    try {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("x-auth-token");
    } catch (error) {
      SharedPreferences.setMockInitialValues({});
    }
    try {
      await http.post(Uri.parse('$uri/userAnswer/reset/category/$category'),
          headers: {"x-auth-token": token!});
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  Future<void> resetAnswersToAllQuestions(
      {required BuildContext context}) async {
    SharedPreferences prefs;
    String? token;
    try {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("x-auth-token");
    } catch (error) {
      SharedPreferences.setMockInitialValues({});
    }
    try {
      await http.post(Uri.parse('$uri/userAnswer/reset'),
          headers: {"x-auth-token": token!});
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }
}
