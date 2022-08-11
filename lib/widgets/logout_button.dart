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
      child: const Text("Logout"),
    );
  }
}
