import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/widgets/day_selector_dialogue.dart';

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final List<String> frequency = ['Daily', 'Weekly', 'Specific date'];
  String _savedName = '';
  String _selectedFrequency = 'Daily';
  List<bool> _selectedDays = [false, false, false, false, false, false, false];

  final formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      var newTodo = Todo(
        title: _savedName,
        isCompleted: false,
        frequency: _selectedFrequency,
      );

      ref.read(todosProvider.notifier).addTodo(newTodo, context);
    }
  }

  void showSelectDaysDialog() {
    showDialog(
      context: context,
      builder:
          (context) => DaySelectorDialogue(
            onAcceptDialog: onAcceptDialog,
            selectedDays: _selectedDays,
          ),
    );
  }

  void onFrequencyChange(String value) {
    setState(() {
      _selectedFrequency = value;
    });

    if (value == 'Weekly') {
      showSelectDaysDialog();
    }
  }

  void onAcceptDialog(List<bool> newValues) {
    setState(() {
      _selectedDays = newValues;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text('this is the date picker');

    if (_selectedFrequency == 'Daily' || _selectedFrequency == 'Weekly') {
      content = SizedBox.shrink();
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
                  maxLength: 20,
                  decoration: InputDecoration(hintText: 'Task Name'),
                ),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton(
                        value: _selectedFrequency,
                        items:
                            frequency.map((frequency) {
                              return DropdownMenuItem(
                                value: frequency,
                                child: Text(frequency),
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

                //RowDays(),
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
