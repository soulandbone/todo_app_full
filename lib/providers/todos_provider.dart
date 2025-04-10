import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todos_app_full/helpers/helper_function.dart';
import 'package:todos_app_full/hive_boxes.dart';
import 'package:todos_app_full/models/todo.dart';

var formatter = DateFormat.yMd();
var today = DateTime.now();

final todosProvider = StateNotifierProvider((ref) {
  return TodosNotifier();
});

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super(Hive.box<Todo>(todoBox).values.toList());

  List<Todo> get completedTodos {
    final List<Todo> completedTodos = [];
    for (int i = 0; i < state.length; i++) {
      if (state[i].isCompleted) {
        completedTodos.add(state[i]);
      }
    }
    return completedTodos;
  }

  //**********************************************************************
  void addTodo(Todo todo, Box<Todo> box) async {
    var newState = [todo, ...state];
    state = newState;

    await box.add(todo);
  }

  //**************************************************************************/
  void removeTodo(Todo todo, Box<Todo> box) async {
    var newState = state.where((element) => (element.id != todo.id)).toList();

    state = newState;
    await box.delete(todo.key);
  }

  //*************************************************************************** */

  void clearTodos(Box<Todo> box) async {
    state = [];
    await box.clear();
  }

  //***************************************************************************** */
  void updateState(Todo todo, Box<Todo> box) async {
    List<Todo> newState = List.from(state);

    var index = state.indexWhere((element) => element.id == todo.id);

    Todo updatedTodo = Todo(
      title: todo.title,
      isCompleted: !todo.isCompleted,
      frequency: todo.frequency,
      creationDate: todo.creationDate,
    );

    newState[index].isCompleted = !state[index].isCompleted;

    if (newState[index].isCompleted) {
      newState[index].completedDate = DateTime.now();
    }

    state = newState;
    await box.putAt(index, updatedTodo);
  }

  //********************************************************************************************* */

  List<Todo> filterByDay(List<Todo> list) {
    var formattedToday = formatter.format(today);
    var dayOfTheWeek = DateFormat.EEEE().format(today).substring(0, 2);
    var index = FunctionHelpers.checkIndexByLabel(dayOfTheWeek);

    List<Todo> filteredList = [];

    print('formatted day today is ${formatter.format(today)}');

    for (Todo todo in list) {
      if (todo.frequency == Frequency.daily) {
        filteredList.add(todo);
      }
      if (todo.frequency == Frequency.weekly &&
          todo.specificDays != null &&
          todo.specificDays![index]) {
        filteredList.add(todo);
      }
      if (todo.frequency == Frequency.specific &&
          todo.specificDate != null &&
          formatter.format(todo.specificDate!) == formattedToday) {
        filteredList.add(todo);
      }
    }

    return filteredList;
  }
}
