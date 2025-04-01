import 'package:flutter/material.dart';
import 'package:todos_app_full/widgets/days_item.dart';

class DaySelectorDialogue extends StatefulWidget {
  const DaySelectorDialogue({required this.selectedDays, super.key});

  final List<bool> selectedDays;

  @override
  State<DaySelectorDialogue> createState() => _DaySelectorDialogueState();
}

class _DaySelectorDialogueState extends State<DaySelectorDialogue> {
  late List<bool> _selectedDaysLocal;

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    _selectedDaysLocal = List.from(widget.selectedDays);
    super.initState();
  }

  void updateWeeklyDay(int index, bool newValue) {
    List<bool> temporalList = _selectedDaysLocal;

    for (int i = 0; i < _selectedDaysLocal.length; i++) {
      if (i == index) {
        temporalList[i] = newValue;
      }
    }

    setState(() {
      _selectedDaysLocal = temporalList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select your days'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < days.length; i++)
              DaysItem(
                index: i,
                label: days[i],
                checkedValue: _selectedDaysLocal[i],
                onSelectWeeklyDay: updateWeeklyDay,
              ),
            TextButton(onPressed: () {}, child: Text('OK')),
          ],
        ),
      ),
    );
  }
}
