import 'package:flutter/material.dart';
import 'package:todos_app_full/widgets/todos_list.dart';

class FilteredTodosScreen extends StatelessWidget {
  const FilteredTodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Today\'s todos')),
      body: TodosList(all: false),
    );
  }
}
