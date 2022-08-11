import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../services/register.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/register";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final RegisterService registerService = RegisterService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

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
                      TextFormField(
                          controller: confirmController,
                          decoration: const InputDecoration(
                              hintText: "Confirm Password"),
                          obscureText: true),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            registerService.registerUser(
                                context: context,
                                username: usernameController.text,
                                password: passwordController.text,
                                confirm: confirmController.text);
                          }
                        },
                        child: Text("Register"),
                      ),
                      Row(
                        children: [
                          const Text("Already have an account?"),
                          ElevatedButton(
                            onPressed: () {
                              SchedulerBinding.instance
                                  .addPostFrameCallback((_) {
                                Navigator.pushReplacementNamed(
                                    context, LoginScreen.routeName);
                              });
                            },
                            child: const Text("Login"),
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
