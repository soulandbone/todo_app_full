import 'package:intl/intl.dart';
import 'package:todos_app_full/models/todo.dart';

class FunctionHelpers {
  static int checkIndexByLabel(String label) {
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

  static String returnDay(int index) {
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

  static String checkDaysSelected(List<bool> list) {
    //  returns a formatted String to show the days that it has been selected
    var readableDays = daysList(list);

    String formattedSelection = listToString(readableDays);
    return formattedSelection;
  }

  static List<String> daysList(List<bool> list) {
    List<String> readableDays = [];
    for (int index = 0; index < list.length; index++) {
      if (list[index]) {
        readableDays.add(returnDay(index));
      }
    }
    return readableDays;
  }

  static String listToString(List<String> list) {
    String variable = ' ';
    for (int i = 0; i < list.length; i++) {
      variable = variable + list[i] + (' ');
    }
    return variable;
  }

  static String enumToString(Frequency frequency) {
    switch (frequency) {
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.specific:
        return 'Specific Date';
    }
  }

  static DateTime calculateFirstDueDate(Todo todo) {
    DateTime? firstDate;
    if (todo.frequency == Frequency.daily) {
      firstDate = todo.creationDate;
    }
    if (todo.frequency == Frequency.specific) {
      firstDate = todo.specificDate!;
    }
    if (todo.frequency == Frequency.weekly) {
      List<String> formattedList = FunctionHelpers.daysList(todo.specificDays!);
      getNextDate(formattedList, todo.creationDate);
    }
    return firstDate!;
  }

  static DateTime getNextDate(List<String> dates, DateTime creationDay) {
    DateTime resultingDate;

    var dayString = DateFormat('EEEE').format(creationDay).substring(0, 2);

    if (dates.contains(dayString)) {
      resultingDate = creationDay;
    } else {
      resultingDate = creationDay.add(Duration(days: 1));
    }
    return resultingDate;
  }
}
