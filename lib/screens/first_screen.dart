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
      bottomNavigationBar: BottomNavigationBar(
        // selectedItemColor: Colors.red,
        // unselectedItemColor: Colors.white,
        // unselectedLabelStyle: TextStyle(color: Colors.white),
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Full List'),
          BottomNavigationBarItem(
            icon: Icon(Icons.adb),
            label: 'Today\'s Todos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Heat Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos),
            label: 'Completed Todos',
          ),
        ],
      ),
    );
  }
}
