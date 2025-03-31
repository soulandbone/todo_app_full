import 'package:flutter/material.dart';
import 'package:todos_app_full/widgets/row_days_item.dart';

class RowDays extends StatefulWidget {
  const RowDays({super.key});

  @override
  State<RowDays> createState() => _RowDaysState();
}

class _RowDaysState extends State<RowDays> {
  List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  List<bool> checkedIndixes = List.generate(
    7,
    (index) => false,
    growable: false,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < days.length; i++)
          RowDaysItem(label: days[i], checkBoxValue: checkedIndixes[i]),
      ],
    );
  }
}
