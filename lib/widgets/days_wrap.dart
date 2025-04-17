import 'package:flutter/material.dart';

import 'package:todos_app_full/widgets/day_chip.dart';

class DaysWrap extends StatefulWidget {
  const DaysWrap({
    required this.listOfDays,
    required this.onChooseDate,
    super.key,
  });

  final Function(String label) onChooseDate;
  final List<bool> listOfDays;
  @override
  State<DaysWrap> createState() => _DaysWrapState();
}

class _DaysWrapState extends State<DaysWrap> {
  List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: [
        for (int index = 0; index < days.length; index++)
          DayChip(
            label: days[index],
            onChooseDate: widget.onChooseDate,
            listOfDays: widget.listOfDays,
          ),
      ],
    );
  }
}
