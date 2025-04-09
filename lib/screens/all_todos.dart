import 'package:flutter/material.dart';
import 'package:todos_app_full/widgets/todos_list.dart';

class AllTodosScreen extends StatelessWidget {
  const AllTodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All todos')),
      body: TodosList(all: true),
    );
  }
}
