import 'package:flutter/material.dart';

class RowDaysItem extends StatelessWidget {
  const RowDaysItem({
    required this.label,
    required this.checkBoxValue,
    super.key,
  });

  final String label;
  final bool checkBoxValue;

  void onTapCheckBox(bool value) {}

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(label),
        Checkbox(value: checkBoxValue, onChanged: (value) {}),
      ],
    );
  }
}
