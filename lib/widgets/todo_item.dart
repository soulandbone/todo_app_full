import 'package:flutter/material.dart';
import 'package:todos_app_full/models/todo.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({required this.todo, super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      child: ListTile(
        leading: Text(todo.title),
        title: Text(todo.title, style: TextStyle(color: Colors.black54)),
        trailing: Checkbox(value: todo.isCompleted, onChanged: null),
      ),
    );
  }
}
