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

  static int getDaysDistance(List<String> dates, DateTime creationDay) {
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
    print('days difference is $daysDifference');
    return daysDifference;
  }

  static DateTime? calculateFirstDueDate(
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
      List<String> formattedList = FunctionHelpers.daysList(specificDays);

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

  static DateTime calculateMostAncientDate(List<Todo> listOfTodos) {
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

  static bool isDueToday(Todo todo, DateTime today) {
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
}
