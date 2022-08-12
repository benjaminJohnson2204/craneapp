import 'option.dart';

class Question {
  final String text;
  final String id;
  final String categoryId;
  final List<Option> options;
  Question(
      {required this.text,
      required this.id,
      required this.categoryId,
      required this.options});
}
