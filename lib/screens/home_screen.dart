import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/screens/category_screen.dart';
import 'package:craneapp/screens/login_screen.dart';
import 'package:craneapp/services/categories.dart';
import 'package:craneapp/services/check_authenticated.dart';
import 'package:craneapp/services/logout.dart';
import 'package:craneapp/services/questions.dart';
import 'package:craneapp/widgets/app_bar.dart';
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
  final QuestionsService questionsService = QuestionsService();
  final CategoriesService categoriesService = CategoriesService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: authenticatedService.checkAuthenticated(context: context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return Scaffold(
                appBar: MyAppBar(context: context),
                backgroundColor: GlobalVariables.backgroundColor,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<Map<String, dynamic>>>(
                            future: categoriesService
                                .getProgressOnAllCategories(context: context),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                return Expanded(
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Welcome!",
                                        textScaleFactor: 4,
                                      ),
                                      const Text(
                                          "Browse questions by category:",
                                          textScaleFactor: 2),
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
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            questionsService
                                                .resetAnswersToAllQuestions(
                                                    context: context)
                                                .then(
                                                  (result) =>
                                                      Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const HomeScreen(),
                                                    ),
                                                  ),
                                                );
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
                                          child: const Text("Reset"),
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
