import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Todo {
  Todo({
    required this.title,
    required this.isCompleted,
    required this.frequency,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final bool isCompleted;
  final String frequency;
}
