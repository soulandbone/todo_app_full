import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:todos_app_full/hive/hive_registrar.g.dart';
import 'package:todos_app_full/hive_boxes.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/screens/first_screen.dart';
import 'package:todos_app_full/theming/app_theme.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapters();

  await Hive.openBox<Todo>(todoBox);
  await Hive.openBox<Todo>(completedTodoBox);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      home: FirstScreen(),
    );
  }
}
