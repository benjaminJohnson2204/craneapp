import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/category.dart';
import 'package:craneapp/screens/CategoryScreen.dart';
import 'package:craneapp/screens/LoginScreen.dart';
import 'package:craneapp/services/categories.dart';
import 'package:craneapp/services/checkAuthenticated.dart';
import 'package:craneapp/services/logout.dart';
import 'package:craneapp/widgets/category_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool authenticated;
  late List<Category> _categories = [Category(id: "1", name: "Test")];
  final CheckAuthenticatedService authenticatedService =
      CheckAuthenticatedService();
  final LogoutService logoutService = LogoutService();
  final CategoriesService categoriesService = CategoriesService();

  @override
  void initState() {
    super.initState();
    authenticatedService
        .checkAuthenticated(context: context)
        .then((bool authenticated) {
      if (!authenticated) {
        Navigator.pushNamed(context, LoginScreen.routeName);
      }
    });
    categoriesService
        .getAllCategories(context: context)
        .then((List<Category> categories) {
      setState(() {
        _categories = categories;
      });
    });
  }

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
                child: ElevatedButton(
                  onPressed: () {
                    logoutService.logout(context: context);
                  },
                  child: const Text("Logout"),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return CategorySelectorWidget(
                          name: _categories[index].name,
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CategoryScreen(
                                      category: _categories[index]),
                                ));
                          });
                    },
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
