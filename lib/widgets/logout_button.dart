import 'package:flutter/material.dart';

import '../services/logout.dart';

class LogoutButtonWidget extends StatelessWidget {
  final LogoutService logoutService = LogoutService();
  LogoutButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        logoutService.logout(context: context);
      },
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
      child: const Text("Logout"),
    );
  }
}
