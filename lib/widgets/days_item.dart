import 'package:flutter/material.dart';

class DaysItem extends StatelessWidget {
  const DaysItem({
    required this.checkedValue,
    required this.index,
    required this.label,
    required this.onSelectWeeklyDay,
    super.key,
  });

  final int index;
  final String label;
  final bool checkedValue;
  final Function(int index, bool newValue) onSelectWeeklyDay;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(label),
        Checkbox(
          value: checkedValue,
          onChanged: (value) {
            onSelectWeeklyDay(index, value!);
          },
        ),
      ],
    );
  }
}
