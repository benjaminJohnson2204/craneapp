import 'package:flutter/material.dart';

import '../constants/global_variables.dart';
import '../screens/CategoryScreen.dart';
import '../screens/HomeScreen.dart';
import '../services/logout.dart';

MyAppBar({required BuildContext context, String? category}) => AppBar(
      backgroundColor: GlobalVariables.topNavbarColor,
      foregroundColor: Colors.black,
      leading: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        },
        child: Icon(Icons.home),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 40.0),
          child: TextButton(
            onPressed: category == null
                ? null
                : () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryScreen(
                          category: category,
                        ),
                      ),
                    );
                  },
            child: category == null
                ? Text("")
                : Text(category,
                    style: TextStyle(color: Colors.black),
                    textScaleFactor: 1.5),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: TextButton(
            onPressed: () {
              LogoutService().logout(context: context);
            },
            child: const Text("Logout",
                style: TextStyle(color: Colors.red), textScaleFactor: 1.5),
          ),
        ),
      ],
    );
