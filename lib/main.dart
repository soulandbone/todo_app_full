import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:todos_app_full/hive/hive_registrar.g.dart';
import 'package:todos_app_full/hive_boxes.dart';

import 'package:todos_app_full/models/todo.dart';
import 'package:todos_app_full/providers/theme_provider.dart';
import 'package:todos_app_full/screens/first_screen.dart';
import 'package:todos_app_full/theming/app_theme.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapters();

  await Hive.openBox<Todo>(todoBox);
  await Hive.openBox<bool>(themeBox);
  await Hive.openBox<DateTime>(lastDayBox);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(themeProvider);

    ThemeMode activeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: activeMode,
      title: 'Flutter Demo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      home: FirstScreen(),
    );
  }
}
