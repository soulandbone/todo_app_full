import 'package:flutter/material.dart';
import 'package:todos_app_full/widgets/days_item.dart';

class DaySelectorDialogue extends StatefulWidget {
  const DaySelectorDialogue({
    required this.onAcceptDialog,
    required this.selectedDays,
    super.key,
  });

  final List<bool> selectedDays;
  final Function(List<bool> values) onAcceptDialog;

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

  void onCheckboxSelect(int index, bool newValue) {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < days.length; i++)
              DaysItem(
                index: i,
                label: days[i],
                checkedValue: _selectedDaysLocal[i],
                onCheckBoxSelect: onCheckboxSelect,
              ),
            TextButton(
              onPressed: () {
                widget.onAcceptDialog(_selectedDaysLocal);
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
