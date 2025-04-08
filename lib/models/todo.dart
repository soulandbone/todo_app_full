import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum Frequency { daily, weekly, specific }

class Todo extends HiveObject {
  Todo({
    required this.title,
    required this.isCompleted,
    required this.frequency,
    this.specificDays,
    this.specificDate,
  }) : id = uuid.v4();

  final String id;
  final String title;
  bool isCompleted;
  final Frequency frequency;
  final List<bool>? specificDays;
  final DateTime? specificDate;
}
