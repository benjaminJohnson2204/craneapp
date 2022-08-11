import 'package:craneapp/models/category.dart';

class QuestionPreview {
  final String text;
  final String id;
  final String categoryId;
  final List<dynamic> options;
  QuestionPreview(
      {required this.text,
      required this.id,
      required this.categoryId,
      required this.options});
}
