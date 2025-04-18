import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todos_app_full/main.dart';

class MyDrawer extends ConsumerStatefulWidget {
  const MyDrawer({super.key});

  @override
  ConsumerState<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> {
  void onUpdateSwitch() {}

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ref.watch(themeProvider);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('MY Todos')),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              isDarkMode = value;
              ref.read(themeProvider.notifier).state = isDarkMode;
            },
          ),
        ],
      ),
    );
  }
}
