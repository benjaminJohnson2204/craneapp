import 'option.dart';

class Question {
  final String text;
  final String id;
  final String category;
  final List<Option> options;
  final List<bool> selectedOptionsIndices;
  Question(
      {required this.text,
      required this.id,
      required this.category,
      required this.options,
      required this.selectedOptionsIndices});
}
