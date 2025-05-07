import 'package:intl/intl.dart';
import 'package:todos_app_full/models/todo.dart';

var formatter = DateFormat.yMd();

class FunctionHelpers {
  int checkIndexByLabel(String label) {
    // based on a label,it returns which index the label comes from considering a boolean list of 7 elements.

    int index = 0;
    switch (label) {
      case 'Mo':
        index = 0;
        break;
      case 'Tu':
        index = 1;
        break;
      case 'We':
        index = 2;
        break;
      case 'Th':
        index = 3;
        break;
      case 'Fr':
        index = 4;
        break;
      case 'Sa':
        index = 5;
        break;
      case 'Su':
        index = 6;
        break;
    }
    return index;
  }

  String returnDay(int index) {
    // based on the index, returns which day it belongs to, considering a list of booleans in which every true element denotes a particular day
    switch (index) {
      case 0:
        return 'Mo';
      case 1:
        return 'Tu';
      case 2:
        return 'We';
      case 3:
        return 'Th';
      case 4:
        return 'Fr';
      case 5:
        return 'Sa';
      case 6:
        return 'Su';
      default:
        return 'NN';
    }
  }

  String checkDaysSelected(List<bool> list) {
    //  returns a formatted String to show the days that it has been selected
    var readableDays = daysList(list);

    String formattedSelection = listToString(readableDays);
    return formattedSelection;
  }

  List<String> daysList(List<bool> list) {
    List<String> readableDays = [];
    for (int index = 0; index < list.length; index++) {
      if (list[index]) {
        readableDays.add(returnDay(index));
      }
    }
    return readableDays;
  }

  String listToString(List<String> list) {
    String variable = ' ';
    for (int i = 0; i < list.length; i++) {
      variable = variable + list[i] + (' ');
    }
    return variable;
  }

  String enumToString(Frequency frequency) {
    switch (frequency) {
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.specific:
        return 'Specific Date';
    }
  }

  int getDaysDistance(List<String> dates, DateTime creationDay) {
    var daysDifference = 0;
    var solved = false;
    var day = creationDay;

    while (!solved) {
      var dayString = DateFormat('EEEE').format(day).substring(0, 2);
      if (dates.contains(dayString)) {
        solved = true;
      } else {
        day = day.add(Duration(days: 1));
        daysDifference += 1;
      }
    }

    return daysDifference;
  }

  DateTime? calculateFirstDueDate(
    // need to format the date
    Frequency frequency,
    DateTime creationDate,
    DateTime? specificDate,
    List<bool>? specificDays,
  ) {
    DateTime? firstDate;
    if (frequency == Frequency.daily) {
      firstDate = DateTime(
        creationDate.year,
        creationDate.month,
        creationDate.day,
      );
    }
    if (frequency == Frequency.specific && specificDate != null) {
      firstDate = specificDate;
    }
    if (frequency == Frequency.weekly && specificDays != null) {
      List<String> formattedList = daysList(specificDays);

      var daysDifference = getDaysDistance(formattedList, creationDate);
      var formattedCreationDate = DateTime(
        creationDate.year,
        creationDate.month,
        creationDate.day,
      );

      firstDate = formattedCreationDate.add(Duration(days: daysDifference));
    }
    return firstDate;
  }

  DateTime calculateMostAncientDate(List<Todo> listOfTodos) {
    if (listOfTodos.isEmpty) {
      return DateTime.now();
    }
    List<DateTime> listOfDueDates = [];
    for (int i = 0; i < listOfTodos.length; i++) {
      if (!listOfDueDates.contains(listOfTodos[i].firstDueDate)) {
        listOfDueDates.add(listOfTodos[i].firstDueDate!);
      }
    }

    var smallestDate = listOfDueDates.reduce(
      (value, element) => element.isBefore(value) ? element : value,
    );
    return smallestDate;
  }

  bool isDueToday(Todo todo, DateTime today) {
    if (todo.frequency == Frequency.daily) {
      return true;
    }
    if (todo.frequency == Frequency.specific) {
      var formattedSpecificDate = DateTime(
        todo.specificDate!.year,
        todo.specificDate!.month,
        todo.specificDate!.day,
      );
      var formattedToday = DateTime(today.year, today.month, today.day);

      if (formattedSpecificDate.isAtSameMomentAs(formattedToday)) {
        return true;
      }
    }
    if (todo.frequency == Frequency.weekly &&
        daysList(
          todo.specificDays!,
        ).contains(DateFormat('EEEE').format(today).substring(0, 2))) {
      return true;
    }
    return false;
  }

  DateTime normalizedDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Map<DateTime, int> computeSummaryFromTodos(List<Todo> todos) {
    Map<String, Map<String, int>> summaryData = {};
    Map<DateTime, int> formattedSummary = {};

    if (todos.isEmpty) {
      return {};
    }

    var firstDate = calculateMostAncientDate(todos);
    //print('First date is $firstDate');
    var currentDay = normalizedDate(firstDate);
    // print('Normalized First date is   $normalizedFirstDate');
    var normalizedToday = normalizedDate(DateTime.now());

    while (currentDay.isBefore(normalizedToday) ||
        currentDay == normalizedToday) {
      var keyDate = formatter.format(currentDay);
      // I start from the first day in the possible dates (until today)
      for (int i = 0; i < todos.length; i++) {
        print(todos[i].completedDates);
        if (isDueToday(todos[i], currentDay)) {
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
