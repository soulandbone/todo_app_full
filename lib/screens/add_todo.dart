import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:todos_app_full/helpers/helper_function.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/widgets/conditional_container.dart';

import 'package:todos_app_full/widgets/days_wrap.dart';

FunctionHelpers helpers = FunctionHelpers();

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final oneYearFromNow = DateTime(DateTime.now().year + 1);

  String _savedName = '';
  Frequency _selectedFrequency = Frequency.daily;
  var dateHasBeenSelected = false;
  var selectSpecificDateIsActive = false;
  late DateTime _selectedDate;
  late DateTime _creationDate;

  String get selectedDateString => DateFormat.yMd().format(_selectedDate);

  List<bool> _selectedDays = List.generate(7, (int i) => false);

  final formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (!_selectedDays.contains(true) &&
        _selectedFrequency == Frequency.weekly) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text('Attention!'),
              iconColor: Colors.amber,
              shadowColor: Colors.purpleAccent,
              icon: Icon(Icons.warning),
              content: SizedBox(
                height: 50,
                child: Text('You need to select some days first'),
              ),
            ),
      );
      return;
    }
    _creationDate = DateTime.now();
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      var firstDueDate = helpers.calculateFirstDueDate(
        _selectedFrequency,
        _creationDate,
        null,
        null,
      );

      if (_selectedFrequency == Frequency.specific) {
        firstDueDate = helpers.calculateFirstDueDate(
          _selectedFrequency,
          _creationDate,
          _selectedDate,
          null,
        );
      }
      if (_selectedFrequency == Frequency.weekly) {
        firstDueDate = helpers.calculateFirstDueDate(
          _selectedFrequency,
          _creationDate,
          null,
          _selectedDays,
        );
      }

      var newTodo = Todo(
        title: _savedName,
        isCompleted: false,
        frequency: _selectedFrequency,
        creationDate: _creationDate,
        specificDays:
            (_selectedFrequency == Frequency.weekly) ? _selectedDays : null,
        specificDate:
            (_selectedFrequency == Frequency.specific) ? _selectedDate : null,
        firstDueDate: firstDueDate,
      );
      ref.read(todosProvider.notifier).addTodo(newTodo);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('You added a new Todo')));
      Navigator.of(context).pop();
    }
  }

  void onFrequencyChange(Frequency value) {
    setState(() {
      _selectedFrequency = value;

      if (_selectedFrequency == Frequency.specific) {
        _selectedDays = List.generate(7, (int i) => false);
        selectSpecificDateIsActive = true;
        openDatePicker(context);
      }
      if (_selectedFrequency == Frequency.daily) {
        _selectedDays = List.generate(7, (int i) => false);
        selectSpecificDateIsActive = false;
      }
      if (_selectedFrequency == Frequency.weekly) {
        selectSpecificDateIsActive = false;
      }
    });
  }

  void onChooseDates(String label) {
    List<bool> newList = List.from(_selectedDays);

    int index = helpers.checkIndexByLabel(label);

    if (index != -1) {
      newList[index] = !_selectedDays[index];
    }
    setState(() {
      _selectedDays = newList;
    });
    //print(_selectedDays);
  }

  Future<void> openDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      currentDate: today,
      firstDate: today,
      lastDate: oneYearFromNow,
    );

    if (pickedDate != null) {
      setState(() {
        dateHasBeenSelected = true;
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ConditionalContainer(childWidget: SizedBox.shrink());

    if (dateHasBeenSelected && selectSpecificDateIsActive) {
      content = Expanded(
        child: Center(
          child: ConditionalContainer(
            childWidget: Text(
              selectedDateString,
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),
          ),
        ),
      );
    } else if (_selectedFrequency == Frequency.weekly) {
      content = Expanded(
        child: ConditionalContainer(
          childWidget: DaysWrap(
            onChooseDate: onChooseDates,
            listOfDays: _selectedDays,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add new Todo item')),
      body: Container(
        //decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: Form(
          key: formKey,

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'You need to enter a valid name';
                    }
                  },
                  onSaved: (value) {
                    if (value == null) {
                      return;
                    }
                    _savedName = value;
                  },
                  maxLength: 25,
                  decoration: InputDecoration(hintText: 'Task Name'),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownMenu(
                        initialSelection: _selectedFrequency,
                        dropdownMenuEntries:
                            Frequency.values.map((frequency) {
                              return DropdownMenuEntry(
                                value: frequency,
                                label: helpers.enumToString(frequency),
                              );
                            }).toList(),
                        onSelected: (value) {
                          onFrequencyChange(value!);
                        },
                      ),
                    ),
                    content,
                  ],
                ),
                Gap(15),
                ElevatedButton(
                  onPressed: () {
                    onSubmit();
                  },
                  child: Text('Add to-do'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
