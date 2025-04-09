import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:todos_app_full/hive/hive_registrar.g.dart';
import 'package:todos_app_full/hive_boxes.dart';
import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/screens/first_screen.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapters();

  await Hive.openBox<Todo>(summaryBox);
  await Hive.openBox<Todo>(todoBox);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
      home: FirstScreen(),
    );
  }
}
