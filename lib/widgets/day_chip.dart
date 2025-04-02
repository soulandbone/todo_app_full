import 'package:flutter/material.dart';
import 'package:todos_app_full/helpers/helper_function.dart';

class DayChip extends StatelessWidget {
  const DayChip({
    required this.onChooseDate,
    required this.listOfDays,
    required this.label,

    super.key,
  });
  final String label;

  final List<bool> listOfDays;
  final Function(String label) onChooseDate;

  bool get isActive => listOfDays[FunctionHelpers.checkIndexByLabel(label)];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChooseDate(label);
      },
      child: Chip(
        label: Text(label),
        backgroundColor: isActive ? Colors.green : Colors.black,
      ),
    );
  }
}
