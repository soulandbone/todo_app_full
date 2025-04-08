import 'package:flutter/material.dart';
import 'package:todos_app_full/screens/heat_map_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Drawer Header')),
          GestureDetector(
            child: ListTile(title: Text('Heat Map')),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => HeatMapScreen()));
            },
          ),
        ],
      ),
    );
  }
}
