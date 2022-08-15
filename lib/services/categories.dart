import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/util.dart';

class CategoriesService {
  Future<List<Category>> getAllCategories(
      {required BuildContext context}) async {
    try {
      http.Response res = await http.get(Uri.parse('$uri/category/all'));
      List<Category> categories = [
        for (var category in jsonDecode(res.body)["categories"])
          Category(name: category)
      ];
      return categories;
    } catch (error) {
      showSnackBar(context, error.toString());
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProgressOnAllCategories(
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
      http.Response res = await http.get(
          Uri.parse('$uri/question/fractionComplete'),
          headers: {"x-auth-token": token!});
      List<Map<String, dynamic>> categories = [];
      for (var category in jsonDecode(res.body)) {
        categories.add({
          "category": Category(name: category["category"]),
          "correct": category["correct"],
          "total": category["total"],
        });
      }
      return categories;
    } catch (error) {
      showSnackBar(context, error.toString());
      return [];
    }
  }

  Future<Map<String, int>> getProgressOnCategory(
      {required BuildContext context, required String category}) async {
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/question/fractionComplete/${category}'));
      return {
        "correct": jsonDecode(res.body)["correct"],
        "total": jsonDecode(res.body)["total"]
      };
    } catch (error) {
      showSnackBar(context, error.toString());
      return {};
    }
  }
}
