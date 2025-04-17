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

FunctionHelpers helpers = FunctionHelpers();

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super(Hive.box<Todo>(todoBox).values.toList());

  Map<DateTime, int>? summaryPerDay() {
    Map<String, Map<String, int>> summaryData = {};
    Map<DateTime, int> formattedSummary = {};

    var todosList = state;

    if (todosList.isEmpty) {
      return null;
    }

    var firstDate = helpers.calculateMostAncientDate(todosList);
    //print('First date is $firstDate');
    var normalizedFirstDate = DateTime(
      firstDate.year,
      firstDate.month,
      firstDate.day,
    );
    // print('Normalized First date is   $normalizedFirstDate');
    var normalizedToday = DateTime(today.year, today.month, today.day);
    var currentDay = normalizedFirstDate;

    while (currentDay.isBefore(normalizedToday) ||
        currentDay == normalizedToday) {
      var keyDate = formatter.format(currentDay);
      // I start from the first day in the possible dates (until today)
      for (int i = 0; i < todosList.length; i++) {
        if (helpers.isDueToday(todosList[i], currentDay)) {
          // if is dueToday then add it to the summary of that particular day
          if (!summaryData.containsKey(keyDate)) {
            summaryData[keyDate] = {'total': 0, 'completed': 0};
          }
          summaryData[keyDate]!['total'] = summaryData[keyDate]!['total']! + 1;
          if (todosList[i].isCompleted) {
            summaryData[keyDate]!['completed'] =
                summaryData[keyDate]!['completed']! + 1;
          }
        }
      }
      currentDay = currentDay.add(Duration(days: 1));
    }

    DateFormat format = DateFormat('M/d/yyyy');

    summaryData.forEach((key, value) {
      DateTime keyDT = format.parse(
        key,
      ); // transform a String into a DateTime object
      if (!formattedSummary.containsKey(keyDT) && value['total'] != null) {
        // so it doesnt repeat the calculation, because it looks for each of the Dates
        if (value['total'] == 0) {
          formattedSummary[keyDT] = 0;
        }
        formattedSummary[keyDT] =
            ((value['completed'])! / (value['total']!) * 100).toInt();
      }
    });

    return formattedSummary;
  }

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
  void addTodo(Todo todo) async {
    var newState = [...state, todo];
    state = newState;

    await Hive.box<Todo>(todoBox).add(todo);
  }

  //**************************************************************************/
  void removeTodo(Todo todo) async {
    var newState = state.where((element) => (element.id != todo.id)).toList();

    state = newState;

    await Hive.box<Todo>(todoBox).delete(todo.key);
  }

  //*************************************************************************** */

  void clearTodos() async {
    state = [];
    await Hive.box<Todo>(todoBox).clear();
  }

  //***************************************************************************** */
  void updateState(Todo todo) async {
    List<Todo> newState = List.from(state);

    var index = state.indexWhere((element) => element.id == todo.id);

    Todo updatedTodo = Todo(
      title: todo.title,
      isCompleted: !todo.isCompleted,
      frequency: todo.frequency,
      creationDate: todo.creationDate,
      firstDueDate: todo.firstDueDate,
      specificDate: todo.specificDate,
      specificDays: todo.specificDays,
    );

    newState[index] = updatedTodo; // new line

    state = newState;

    await Hive.box<Todo>(todoBox).putAt(index, updatedTodo);
  }

  //********************************************************************************************* */

  List<Todo> filterByDay(List<Todo> list) {
    var formattedToday = formatter.format(today);
    var dayOfTheWeek = DateFormat.EEEE().format(today).substring(0, 2);
    var index = helpers.checkIndexByLabel(dayOfTheWeek);

    List<Todo> filteredList = [];

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
