import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../constants/util.dart';
import '../models/option.dart';
import '../models/question.dart';

class QuestionsService {
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
                  Option(
                      text: option["text"],
                      isCorrect: option["isCorrect"] == "true")
              ],
              categoryId: question["category"])
      ];
      return result;
    } catch (error) {
      showSnackBar(context, error.toString());
      return [];
    }
  }

  Future<Question> getQuestionById(
      {required BuildContext context, required String id}) async {
    try {
      http.Response res = await http.get(Uri.parse('$uri/question/$id'));
      dynamic question = jsonDecode(res.body)["question"];
      print(question["options"][0].isCorrect);
      print(question["options"][1].isCorrect);
      return Question(
          text: question["questionText"],
          id: question["_id"],
          options: [
            for (var option in question["options"])
              Option(
                  text: option["text"],
                  isCorrect: option["isCorrect"] == "true")
          ],
          categoryId: question["category"]);
    } catch (error) {
      showSnackBar(context, error.toString());
      return Question(
          text: "error", id: "error", options: [], categoryId: "error");
    }
  }
}
