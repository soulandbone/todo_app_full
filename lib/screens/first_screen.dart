import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/screens/add_todo.dart';
import 'package:todos_app_full/screens/all_todos.dart';
import 'package:todos_app_full/screens/completed_todos.dart';
import 'package:todos_app_full/screens/filtered_todos.dart';
import 'package:todos_app_full/screens/heat_map_screen.dart';

import 'package:todos_app_full/widgets/drawer.dart';

class FirstScreen extends ConsumerStatefulWidget {
  const FirstScreen({super.key});

  @override
  ConsumerState<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends ConsumerState<FirstScreen> {
  var _currentIndex = 1;

  List<Widget> activeScreen = [
    AllTodosScreen(),
    FilteredTodosScreen(),
    HeatMapScreen(),
    CompletedTodosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
              ref.read(todosProvider.notifier).clearTodos();
            },
          ),
        ],
      ),
      body: activeScreen[_currentIndex],

      bottomNavigationBar: NavigationBar(
        //backgroundColor: Colors.amber,
        onDestinationSelected: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        selectedIndex: _currentIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.all_inbox),
            label: 'All Todos',
          ),
          NavigationDestination(
            icon: Icon(Icons.filter),
            label: 'Today\'s todos',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Heat Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.done),
            label: 'Completed Todos',
          ),
        ],
      ),
    );
  }
}
