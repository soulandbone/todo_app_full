import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todos_app_full/helpers/helper_function.dart';
import 'package:todos_app_full/hive_boxes.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({required this.todo, super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formatter = DateFormat.MMMd();
    var box = Hive.box<Todo>(todoBox);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.amber,
      child: Dismissible(
        key: ValueKey(todo.id),
        onDismissed: (direction) {
          ref.read(todosProvider.notifier).removeTodo(todo, box);
        },
        child: ListTile(
          title: Text(
            todo.title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            todo.specificDate != null
                ? formatter.format(todo.specificDate!)
                : todo.specificDays == null
                ? ' Daily'
                : FunctionHelpers.checkDaysSelected(todo.specificDays!),
            style: TextStyle(color: Colors.black),
          ),
          trailing: Checkbox(
            side: BorderSide(color: Colors.green),
            activeColor: Colors.red,
            value: todo.isCompleted,
            onChanged: (value) {
              ref.read(todosProvider.notifier).updateState(todo, box);
            },
          ),
        ),
      ),
    );
  }
}
