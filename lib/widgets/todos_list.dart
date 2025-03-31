import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/widgets/todo_item.dart';

class TodosList extends ConsumerWidget {
  const TodosList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todosList = ref.watch(todosProvider);

    Widget content =
        todosList.isEmpty
            ? Center(child: Text('There are no to-dos'))
            : ListView.builder(
              itemCount: todosList.length,
              itemBuilder: (context, index) => TodoItem(todo: todosList[index]),
            );

    return content;
  }
}
