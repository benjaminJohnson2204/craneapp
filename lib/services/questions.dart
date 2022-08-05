import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/category.dart';
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
      List<dynamic> questions = jsonDecode(res.body)["questions"].map(
          (question) => Question(
              text: jsonDecode(question)["text"],
              id: jsonDecode(question)["_id"],
              options: jsonDecode(question)["options"],
              category: jsonDecode(question)["category"]));
      return questions;
    } catch (error) {
      showSnackBar(context, error.toString());
      return [];
    }
  }
}
