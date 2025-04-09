import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/widgets/todo_item.dart';

class TodosList extends ConsumerWidget {
  const TodosList({required this.all, super.key});

  final bool all;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var readingList = ref.read(todosProvider);

    for (int i = 0; i < readingList.length; i++) {
      print(readingList[i].frequency);
    }
    List<Todo> todosList = ref.watch(todosProvider);
    List<Todo> filteredList = ref
        .watch(todosProvider.notifier)
        .filterByDay(todosList);

    final List<Todo> activeList;

    if (all) {
      activeList = todosList;
    } else {
      activeList = filteredList;
    }

    Widget content =
        activeList.isEmpty
            ? Center(child: Text('There are no to-dos'))
            : ListView.builder(
              itemCount: activeList.length,
              itemBuilder:
                  (context, index) => TodoItem(todo: activeList[index]),
            );

    return content;
  }
}
