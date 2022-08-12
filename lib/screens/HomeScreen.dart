import 'package:craneapp/constants/global_variables.dart';
import 'package:craneapp/models/category.dart';
import 'package:craneapp/screens/CategoryScreen.dart';
import 'package:craneapp/screens/LoginScreen.dart';
import 'package:craneapp/services/categories.dart';
import 'package:craneapp/services/checkAuthenticated.dart';
import 'package:craneapp/services/logout.dart';
import 'package:craneapp/widgets/category_selector.dart';
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
  void initState() {
    super.initState();
    authenticatedService
        .checkAuthenticated(context: context)
        .then((bool authenticated) {
      if (!authenticated) {
        Navigator.pushNamed(context, LoginScreen.routeName);
      }
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
                child: LogoutButtonWidget(),
              ),
              FutureBuilder<List<Category>>(
                  future: categoriesService.getAllCategories(context: context),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return CategorySelectorWidget(
                                  name: snapshot.data![index].name,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CategoryScreen(
                                              category: snapshot.data![index]),
                                        ));
                                  });
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
