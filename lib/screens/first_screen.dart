import 'package:flutter/material.dart';
import 'package:todos_app_full/screens/add_todo.dart';
import 'package:todos_app_full/widgets/todos_list.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      body: TodosList(),
    );
  }
}
