import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/util.dart';

class LoginService {
  void loginUser(
      {required BuildContext context,
      required String username,
      required String password}) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/auth/login'),
          body: jsonEncode({"username": username, "password": password}),
          headers: <String, String>{"Content-Type": "application/json"});
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("x-auth-token", jsonDecode(res.body)["token"]);
      } catch (error) {
        SharedPreferences.setMockInitialValues({});
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      });
    } catch (error) {
      print(error.toString());
      showSnackBar(context, error.toString());
    }
  }
}
