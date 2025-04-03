import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({required this.todo, super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(todo.id),
      child: ListTile(
        leading: Text(todo.title),
        title: Text(todo.title, style: TextStyle(color: Colors.black54)),
        trailing: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            ref.read(todosProvider.notifier).updateState(todo);
          },
        ),
      ),
    );
  }
}
