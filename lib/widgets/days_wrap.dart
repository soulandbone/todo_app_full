import 'package:flutter/material.dart';
import 'package:todos_app_full/widgets/day_chip.dart';

class DaysWrap extends StatefulWidget {
  const DaysWrap({super.key});

  @override
  State<DaysWrap> createState() => _DaysWrapState();
}

class _DaysWrapState extends State<DaysWrap> {
  List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        for (int index = 0; index < days.length; index++)
          DayChip(label: days[index]),
      ],
    );
  }
}
