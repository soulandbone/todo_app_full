import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/providers/theme_provider.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(themeProvider); //watches the state
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('MY Todos')),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode!,
            onChanged: (value) {
              ref.read(themeProvider.notifier).updateTheme(value);
            },
          ),
        ],
      ),
    );
  }
}
