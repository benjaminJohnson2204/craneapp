import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/screens/CategoryScreen.dart';
import 'package:craneapp/screens/LoginScreen.dart';
import 'package:craneapp/services/categories.dart';
import 'package:craneapp/services/checkAuthenticated.dart';
import 'package:craneapp/services/logout.dart';
import 'package:craneapp/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CheckAuthenticatedService authenticatedService =
      CheckAuthenticatedService();
  final LogoutService logoutService = LogoutService();
  final CategoriesService categoriesService = CategoriesService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: authenticatedService.checkAuthenticated(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
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
                          child: LogoutButtonWidget(),
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                            future: categoriesService
                                .getProgressOnAllCategories(context: context),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                          "Browse questions by category:"),
                                      SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            CategoryScreen(
                                                                category: snapshot
                                                                            .data![
                                                                        index][
                                                                    "category"]),
                                                      ));
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          snapshot.data![index][
                                                                      "correct"] ==
                                                                  snapshot.data![
                                                                          index]
                                                                      ["total"]
                                                              ? Colors.green
                                                              : Colors.blue),
                                                ),
                                                child: Text(
                                                    '${snapshot.data![index]["category"]}: ${snapshot.data![index]["correct"]} / ${snapshot.data![index]["total"]}'));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            })),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              Navigator.pushNamed(context, LoginScreen.routeName);
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
