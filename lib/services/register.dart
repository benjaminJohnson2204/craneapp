import 'dart:convert';

import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/screens/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/error_handling.dart';
import '../constants/util.dart';

class RegisterService {
  void registerUser(
      {required BuildContext context,
      required String username,
      required String password,
      required String confirm}) async {
    try {
      http.Response res = await http.post(Uri.parse('$uri/auth/register'),
          body: jsonEncode(
              {"username": username, "password": password, "confirm": confirm}),
          headers: <String, String>{"Content-Type": "application/json"});
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            try {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                  "x-auth-token", jsonDecode(res.body)["token"]);
            } catch (error) {
              SharedPreferences.setMockInitialValues({});
            }
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            });
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }
}
