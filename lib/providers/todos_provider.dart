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

var newDay = false;

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier()
    : super(
        loadResettedTodos(),
      ); // TodosNotifier() : super(Hive.box<Todo>(todoBox).values.toList());

  Map<DateTime, int> summaryPerDay() {
    Map<String, Map<String, int>> summaryData = {};
    Map<DateTime, int> formattedSummary = {};

    var todosList = state;

    if (todosList.isEmpty) {
      return {};
    }

    var firstDate = helpers.calculateMostAncientDate(todosList);
    //print('First date is $firstDate');
    var currentDay = helpers.normalizedDate(firstDate);
    // print('Normalized First date is   $normalizedFirstDate');
    var normalizedToday = helpers.normalizedDate(today);

    while (currentDay.isBefore(normalizedToday) ||
        currentDay == normalizedToday) {
      var keyDate = formatter.format(currentDay);
      // I start from the first day in the possible dates (until today)
      for (int i = 0; i < todosList.length; i++) {
        print(todosList[i].completedDates);
        if (helpers.isDueToday(todosList[i], currentDay)) {
          // if is 'dueToday' then add it to the summary of that particular day
          if (!summaryData.containsKey(keyDate)) {
            summaryData[keyDate] = {'total': 0, 'completed': 0};
          }
          summaryData[keyDate]!['total'] = summaryData[keyDate]!['total']! + 1;
          if (todosList[i].completedDates != null &&
              todosList[i].completedDates!.contains(currentDay)) {
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

  static List<Todo> loadResettedTodos() {
    final Box<DateTime> dayBox = Hive.box<DateTime>(lastDayBox);

    var normalizedToday = helpers.normalizedDate(today);

    var lastDay = dayBox.get('lastDay', defaultValue: today);
    var todosList = Hive.box<Todo>(todoBox).values.toList();

    if (normalizedToday.isAfter(lastDay!)) {
      var newState =
          todosList.map((e) => e.copyWith(isCompleted: false)).toList();
      todosList = newState;
    }
    return todosList;
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

  // void clearTodos() async {  // Eliminated this option as it was too easy to make a mistake and delete all Todos. Will bring it back, when I implement a Alert Dialog to confirm the action.
  //   state = [];
  //   await Hive.box<Todo>(todoBox).clear();
  // }

  //***************************************************************************** */
  void updateState(Todo todo) async {
    // You can only update completed status if the todo is on Today

    var normalizedToday = helpers.normalizedDate(today);
    List<Todo> newState = List.from(state);

    var index = state.indexWhere((element) => element.id == todo.id);
    List<DateTime> newCompletedDates = [];
    var oldCompletedDates = todo.completedDates ?? [];
    print('state of todo is ${todo.isCompleted}');
    if (!todo.isCompleted) {
      // Todo is not completed originally
      newCompletedDates = [
        ...oldCompletedDates,
        normalizedToday,
      ]; // then I take the previous dates and I add todays day, because the moment this method calls its because there has bbeen a change in the completed status
      await Hive.box<DateTime>(lastDayBox).put('lastDay', normalizedToday);
    }

    if (todo.isCompleted) {
      newCompletedDates =
          oldCompletedDates
              .where((index) => index != normalizedToday)
              .toList(); // return a list that doesnt include today

      print('new completedDates = $newCompletedDates');
    }

    Todo updatedTodo = Todo(
      title: todo.title,
      isCompleted: !todo.isCompleted,
      frequency: todo.frequency,
      creationDate: todo.creationDate,
      firstDueDate: todo.firstDueDate,
      specificDate: todo.specificDate,
      specificDays: todo.specificDays,
      completedDates: newCompletedDates,
    );
    print('completed state of updatedTodo is ${updatedTodo.isCompleted}');
    newState[index] = updatedTodo; // new line
    print(
      'Completed dates of Updated Todo ${updatedTodo.title} are ${updatedTodo.completedDates}',
    );
    state = newState;

    await Hive.box<Todo>(todoBox).putAt(index, updatedTodo);
    await Hive.box<DateTime>(lastDayBox).put('lastDay', normalizedToday);
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

  Map<DateTime, int> computeSummaryFromTodos(List<Todo> todos) {
    Map<String, Map<String, int>> summaryData = {};
    Map<DateTime, int> formattedSummary = {};

    if (todos.isEmpty) {
      return {};
    }

    var firstDate = helpers.calculateMostAncientDate(todos);
    //print('First date is $firstDate');
    var currentDay = helpers.normalizedDate(firstDate);
    // print('Normalized First date is   $normalizedFirstDate');
    var normalizedToday = helpers.normalizedDate(today);

    while (currentDay.isBefore(normalizedToday) ||
        currentDay == normalizedToday) {
      var keyDate = formatter.format(currentDay);
      // I start from the first day in the possible dates (until today)
      for (int i = 0; i < todos.length; i++) {
        print(todos[i].completedDates);
        if (helpers.isDueToday(todos[i], currentDay)) {
          // if is 'dueToday' then add it to the summary of that particular day
          if (!summaryData.containsKey(keyDate)) {
            summaryData[keyDate] = {'total': 0, 'completed': 0};
          }
          summaryData[keyDate]!['total'] = summaryData[keyDate]!['total']! + 1;
          if (todos[i].completedDates != null &&
              todos[i].completedDates!.contains(currentDay)) {
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
}
