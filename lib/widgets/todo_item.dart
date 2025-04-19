import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:todos_app_full/helpers/helper_function.dart';

import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/todos_provider.dart';
import 'package:todos_app_full/theming/color_palette.dart';

FunctionHelpers helpers = FunctionHelpers();

class TodoItem extends ConsumerWidget {
  const TodoItem({required this.todo, required this.showCheckBox, super.key});

  final Todo todo;
  final bool showCheckBox;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formatter = DateFormat.MMMd();

    ColorPalette colorPalette = ColorPalette();
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color:
          colorScheme
              .surface, //colorPalette.darkColorScheme.secondaryContainer,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: Dismissible(
        key: ValueKey(todo.id),
        onDismissed: (direction) {
          ref.read(todosProvider.notifier).removeTodo(todo);
        },
        child: ListTile(
          title: Text(
            todo.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            todo.specificDate != null
                ? formatter.format(todo.specificDate!)
                : todo.specificDays == null
                ? ' Daily'
                : helpers.checkDaysSelected(todo.specificDays!),
          ),
          trailing:
              showCheckBox
                  ? Checkbox(
                    // side: BorderSide(color: Colors.green),
                    // activeColor: Colors.red,
                    value: todo.isCompleted,
                    onChanged: (value) {
                      ref.read(todosProvider.notifier).updateState(todo);
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
