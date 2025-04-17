import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/widgets/todo_item.dart';

class CompletedTodosScreen extends ConsumerWidget {
  const CompletedTodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var completedTodos = ref.watch(todosProvider.notifier).completedTodos;

    Widget content = Center(child: Text('There are no completed Todos'));
    if (completedTodos.isNotEmpty) {
      content = ListView.builder(
        itemCount: completedTodos.length,
        itemBuilder:
            (context, index) =>
                TodoItem(todo: completedTodos[index], showCheckBox: false),
      );
    }

    return Scaffold(body: content);
  }
}
