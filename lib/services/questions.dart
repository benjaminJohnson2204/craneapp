import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../constants/util.dart';
import '../models/option.dart';
import '../models/question.dart';

class QuestionsService {
  Map<String, List<Question>> questionsByCategory = {};

  Future<List<Question>> getQuestionsUnderCategory(
      {required BuildContext context, required String category}) async {
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/question/category/$category'));
      List<Question> result = [
        for (var question in jsonDecode(res.body)["questions"])
          Question(
              text: question["questionText"],
              id: question["_id"],
              options: [
                for (var option in question["options"])
                  Option(text: option["text"], isCorrect: option["isCorrect"])
              ],
              category: question["category"])
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

  // Future<Question> getQuestionById(
  //     {required BuildContext context, required String id}) async {
  //   try {
  //     http.Response res = await http.get(Uri.parse('$uri/question/$id'));
  //     dynamic question = jsonDecode(res.body)["question"];
  //     return Question(
  //         text: question["questionText"],
  //         id: question["_id"],
  //         options: [
  //           for (var option in question["options"])
  //             Option(text: option["text"], isCorrect: option["isCorrect"])
  //         ],
  //         category: question["category"]);
  //   } catch (error) {
  //     showSnackBar(context, error.toString());
  //     return Question(
  //         text: "error", id: "error", options: [], category: "error");
  //   }
  // }
}
