import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todos_app_full/hive_boxes.dart';
import 'package:todos_app_full/models/todo.dart';

final todosProvider = StateNotifierProvider((ref) {
  return TodosNotifier();
});

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super(Hive.box<Todo>(todoBox).values.toList());

  void addTodo(Todo todo, BuildContext context, Box<Todo> box) {
    var newState = [todo, ...state];
    state = newState;
    Navigator.of(context).pop();
    box.put(todo.id, todo);
  }

  void removeTodo(Todo todo, Box<Todo> box) {
    var newState = state.where((element) => (element.id != todo.id)).toList();

    state = newState;
    box.delete(todo.key);
  }

  void updateState(Todo todo) {
    List<Todo> newState = List.from(state);

    var index = state.indexWhere((element) => element.id == todo.id);

    newState[index].isCompleted = !state[index].isCompleted;

    state = newState;
  }
}
