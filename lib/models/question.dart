import 'package:craneapp/models/category.dart';

class Question {
  final String text;
  final String id;
  final Category category;
  final List<dynamic> options;
  Question(
      {required this.text,
      required this.id,
      required this.category,
      required this.options});
}
