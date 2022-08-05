import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/error_handling.dart';
import '../constants/util.dart';

class CheckAuthenticatedService {
  Future<bool> checkAuthenticated({required BuildContext context}) async {
    SharedPreferences prefs;
    String? token;
    try {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("x-auth-token");
    } catch (error) {
      SharedPreferences.setMockInitialValues({});
    }
    try {
      http.Response res = await http.post(Uri.parse('$uri/auth/tokenIsValid'),
          headers: {"x-auth-token": token!});
      return jsonDecode(res.body)["valid"];
    } catch (error) {
      print(error.toString());
      showSnackBar(context, error.toString());
      return false;
    }
  }
}
