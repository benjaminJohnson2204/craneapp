import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/category.dart';
import 'package:craneapp/screens/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

import '../constants/error_handling.dart';
import '../constants/util.dart';

class CategoriesService {
  Future<List<Category>> getAllCategories(
      {required BuildContext context}) async {
    try {
      http.Response res = await http.get(Uri.parse('$uri/category/all'));
      List<Category> categories = [
        for (var category in jsonDecode(res.body)["categories"])
          Category(name: category["name"], id: category["_id"])
      ];
      return categories;
    } catch (error) {
      showSnackBar(context, error.toString());
      return [];
    }
  }
}
