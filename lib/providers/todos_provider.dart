import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todos_app_full/hive_boxes.dart';
import 'package:todos_app_full/models/todo.dart';

final todosProvider = StateNotifierProvider((ref) {
  return TodosNotifier();
});

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super(Hive.box<Todo>(todoBox).values.toList());

  void addTodo(Todo todo, BuildContext context, Box<Todo> box) async {
    var newState = [todo, ...state];
    state = newState;
    Navigator.of(context).pop();
    await box.add(todo);
  }

  void removeTodo(Todo todo, Box<Todo> box) async {
    var newState = state.where((element) => (element.id != todo.id)).toList();

    state = newState;
    await box.delete(todo.key);
  }

  void clearTodos(Box<Todo> box) async {
    state = [];
    await box.clear();
  }

  void updateState(Todo todo, Box<Todo> box) async {
    List<Todo> newState = List.from(state);

    var index = state.indexWhere((element) => element.id == todo.id);

    Todo updatedTodo = Todo(
      title: todo.title,
      isCompleted: !todo.isCompleted,
      frequency: todo.frequency,
    );
    var today = DateTime.now();
    var dayOfTheWeek = DateFormat.EEEE().format(today).substring(0, 2);
    print('Today is $dayOfTheWeek');

    newState[index].isCompleted = !state[index].isCompleted;

    state = newState;
    await box.putAt(index, updatedTodo);
  }

  List<Todo> filterByDay(List<Todo> list) {
    var today = DateTime.now();
    var dayOfTheWeek = DateFormat.EEEE().format(today).substring(0, 1);

    for (Todo todo in state) {}

    return [Todo(title: 'b;ab', isCompleted: true, frequency: 'Weekly')];
  }
}
