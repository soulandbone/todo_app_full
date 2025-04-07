import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Todo extends HiveObject {
  Todo({
    required this.title,
    required this.isCompleted,
    required this.frequency,
  }) : id = uuid.v4();

  final String id;
  final String title;
  bool isCompleted;
  final String frequency;
}
