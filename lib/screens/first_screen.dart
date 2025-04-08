import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todos_app_full/hive_boxes.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/screens/add_todo.dart';
import 'package:todos_app_full/widgets/todos_list.dart';

class FirstScreen extends ConsumerWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var box = Hive.box<Todo>(todoBox);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => AddTodo()));
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ref.read(todosProvider.notifier).clearTodos(box);
            },
          ),
        ],
      ),
      body: TodosList(),
    );
  }
}
