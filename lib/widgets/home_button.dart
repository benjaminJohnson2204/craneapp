import 'package:craneapp/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class HomeButtonWidget extends StatelessWidget {
  const HomeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        },
        child: const Text("Home"));
  }
}
