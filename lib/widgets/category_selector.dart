import 'package:flutter/material.dart';

class CategorySelectorWidget extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const CategorySelectorWidget(
      {Key? key, required this.name, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onTap, child: Text(name));
  }
}
