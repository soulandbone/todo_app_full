import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todos_app_full/helpers/helper_function.dart';
import 'package:todos_app_full/hive_boxes.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/widgets/conditional_container.dart';

import 'package:todos_app_full/widgets/days_wrap.dart';

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final today = DateTime.now();
  final oneYearFromNow = DateTime(DateTime.now().year + 1);

  String _savedName = '';
  Frequency _selectedFrequency = Frequency.daily;
  bool dateHasBeenSelected = false;
  bool selectSpecificDateIsActive = false;
  late DateTime _selectedDate;

  String get selectedDateString => DateFormat.yMd().format(_selectedDate);

  List<bool> _selectedDays = [false, false, false, false, false, false, false];

  final formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      Todo newTodo;

      if (_selectedFrequency == Frequency.weekly) {
        //Weekly
        //print('Weekly has been selected');
        newTodo = Todo(
          title: _savedName,
          isCompleted: false,
          frequency: _selectedFrequency,
          specificDays: _selectedDays,
        );
      } else if (_selectedFrequency == Frequency.specific) {
        // print('specific  has been selected');
        newTodo = Todo(
          title: _savedName,
          isCompleted: false,
          frequency: _selectedFrequency,
          specificDate: _selectedDate,
        );
      } else {
        //print('Daily has been selected');
        newTodo = Todo(
          title: _savedName,
          isCompleted: false,
          frequency: _selectedFrequency,
        );
        // print(_selectedFrequency);
      }

      var box = Hive.box<Todo>(todoBox);

      ref.read(todosProvider.notifier).addTodo(newTodo, context, box);
    }
  }

  void onFrequencyChange(Frequency value) {
    setState(() {
      _selectedFrequency = value;
      if (_selectedFrequency == Frequency.specific) {
        selectSpecificDateIsActive = true;
        openDatePicker(context);
      } else if (_selectedFrequency == Frequency.daily ||
          _selectedFrequency == Frequency.weekly) {
        selectSpecificDateIsActive = false;
      }
    });
  }

  void onChooseDates(String label) {
    List<bool> newList = List.from(_selectedDays);

    int index = FunctionHelpers.checkIndexByLabel(label);

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
        // decoration: BoxDecoration(color: Colors.amber),
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
                      child: DropdownButton(
                        value: _selectedFrequency,
                        items:
                            Frequency.values.map((frequency) {
                              return DropdownMenuItem(
                                value: frequency,
                                child: Text(
                                  FunctionHelpers.enumToString(frequency),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          onFrequencyChange(value!);
                        },
                      ),
                    ),
                    content,
                  ],
                ),
                Gap(10),
                TextButton(
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
