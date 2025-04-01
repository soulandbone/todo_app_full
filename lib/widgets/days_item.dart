import 'package:flutter/material.dart';

class DaysItem extends StatelessWidget {
  const DaysItem({
    required this.checkedValue,
    required this.index,
    required this.label,
    required this.onCheckBoxSelect,
    super.key,
  });

  final int index;
  final String label;
  final bool checkedValue;
  final Function(int index, bool newValue) onCheckBoxSelect;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: checkedValue,
      onChanged: (value) {
        onCheckBoxSelect(index, value!);
      },
    );
  }
}
