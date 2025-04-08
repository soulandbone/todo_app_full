class FunctionHelpers {
  static int checkIndexByLabel(String label) {
    int index = 0;
    switch (label) {
      case 'Mo':
        index = 0;
      case 'Tu':
        index = 1;
      case 'We':
        index = 2;
      case 'Th':
        index = 3;
      case 'Fr':
        index = 4;
      case 'Sa':
        index = 5;
      case 'Su':
        index = 6;
      default:
        index = -1;
    }
    return index;
  }

  static String returnDay(int index) {
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
    List<String> readableDays = [];

    for (int index = 0; index < list.length; index++) {
      if (list[index]) {
        readableDays.add(returnDay(index));
      }
    }

    String formattedSelection = listToString(readableDays);
    return formattedSelection;
  }

  static String listToString(List<String> list) {
    String variable = ' ';
    for (int i = 0; i < list.length; i++) {
      variable = variable + list[i] + (' ');
    }
    return variable;
  }
}
