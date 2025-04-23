import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum Frequency { daily, weekly, specific }

class Todo extends HiveObject {
  Todo({
    required this.creationDate,
    required this.title,
    required this.isCompleted,
    required this.frequency,
    this.specificDays,
    this.specificDate,
    this.completedDates,
    required this.firstDueDate,
  }) : id = uuid.v4();

  final DateTime creationDate;
  final String id;
  final String title;
  bool isCompleted;
  final Frequency frequency;
  final List<bool>? specificDays;
  final DateTime? specificDate;
  final DateTime? firstDueDate;
  final List<DateTime>? completedDates;

  @override
  String toString() {
    return 'Todo{title: $title, isCompleted: $isCompleted, creationDate: $creationDate, firstdueDate: $firstDueDate, frequency: $frequency}';
  }

  Todo copyWith({
    String? title,
    bool? isCompleted,

    // Add other properties if needed
  }) {
    return Todo(
      creationDate: creationDate, // ID should remain the same
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      frequency: frequency,
      specificDays: specificDays,
      specificDate: specificDate,
      firstDueDate: firstDueDate,
      completedDates: completedDates,
    );
  }
}
