import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/option.dart';
import 'package:craneapp/models/questionPreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../constants/util.dart';
import '../models/question.dart';

class QuestionsService {
  Future<List<QuestionPreview>> getQuestionsUnderCategory(
      {required BuildContext context, required String id}) async {
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/question/category/$id'));
      List<QuestionPreview> result = [];
      for (var question in jsonDecode(res.body)["questions"]) {
        List<String> optionIds = [];
        for (var option in question["options"]) {
          optionIds.add(option.toString());
        }
        result.add(QuestionPreview(
            text: question["questionText"],
            id: question["_id"],
            optionIds: optionIds,
            categoryId: question["category"]));
      }
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
      List<Option> options = [];
      for (var option in jsonDecode(res.body)["options"]) {
        options
            .add(Option(text: option["text"], isCorrect: option["isCorrect"]));
      }
      return Question(
          text: question["questionText"],
          id: question["_id"],
          options: options,
          categoryId: question["category"]);
    } catch (error) {
      showSnackBar(context, error.toString());
      return Question(
          text: "error", id: "error", options: [], categoryId: "error");
    }
  }
}
