import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapScreen extends StatelessWidget {
  const HeatMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: HeatMapCalendar(
          flexible: true,
          datasets: {
            DateTime(2025, 4, 1): 3,
            DateTime(2025, 4, 3): 7,
            DateTime(2025, 4, 4): 10,
            DateTime(2025, 4, 5): 13,
            DateTime(2025, 4, 6): 6,
          },
          colorsets: {
            1: Colors.red,
            3: Colors.orange,
            5: Colors.yellow,
            7: Colors.green,
            9: Colors.blue,
            11: Colors.indigo,
            13: Colors.purple,
          },
        ),
      ),
    );
  }
}
