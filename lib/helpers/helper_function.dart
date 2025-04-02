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
}
