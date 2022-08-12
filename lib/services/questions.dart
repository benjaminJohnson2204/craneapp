import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/category.dart';
import 'package:craneapp/models/option.dart';
import 'package:craneapp/models/questionPreview.dart';
import 'package:craneapp/screens/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

import '../constants/error_handling.dart';
import '../constants/util.dart';
import '../models/question.dart';

class QuestionsService {
  Future<List<dynamic>> getQuestionsUnderCategory(
      {required BuildContext context, required String id}) async {
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/question/category/$id'));
      return jsonDecode(res.body)["questions"]
          .map((question) => QuestionPreview(
              text: question["questionText"],
              id: question["_id"],
              options: question["options"],
              categoryId: question["category"]))
          .toList();
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
      return Question(
          text: question["questionText"],
          id: question["_id"],
          options: jsonDecode(res.body)["options"]
              .map((option) =>
                  Option(text: option["text"], isCorrect: option["isCorrect"]))
              .toList(),
          categoryId: question["category"]);
    } catch (error) {
      showSnackBar(context, error.toString());
      return Question(
          text: "error", id: "error", options: [], categoryId: "error");
    }
  }
}
