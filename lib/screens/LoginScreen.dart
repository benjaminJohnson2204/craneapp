import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../services/login.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final LoginService loginService = LoginService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome"),
              Container(
                padding: const EdgeInsets.all(8),
                color: GlobalVariables.backgroundColor,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(hintText: "Username"),
                      ),
                      TextFormField(
                          controller: passwordController,
                          decoration:
                              const InputDecoration(hintText: "Password"),
                          obscureText: true),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            loginService.loginUser(
                                context: context,
                                username: usernameController.text,
                                password: passwordController.text);
                          }
                        },
                        child: const Text("Login"),
                      ),
                      Row(
                        children: [
                          const Text("New to the app?"),
                          ElevatedButton(
                            onPressed: () {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacementNamed(
                                    context, RegisterScreen.routeName);
                              });
                            },
                            child: const Text("Register"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
