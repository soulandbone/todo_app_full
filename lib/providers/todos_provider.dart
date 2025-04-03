import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/models/todo.dart';

final todosProvider = StateNotifierProvider((ref) {
  return TodosNotifier();
});

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void addTodo(Todo todo, BuildContext context) {
    var newState = [todo, ...state];
    state = newState;
    Navigator.of(context).pop();
    print('State is ${state[0].title}');
  }

  void removeTodo(Todo todo) {
    var newState = state.where((element) => (element.id != todo.id));
  }

  void updateState(Todo todo) {
    List<Todo> newState = List.from(state);

    var index = state.indexWhere((element) => element.id == todo.id);

    newState[index].isCompleted = !state[index].isCompleted;

    state = newState;
  }
}
