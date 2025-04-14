import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/providers/todos_provider.dart';

class HeatMapScreen extends ConsumerWidget {
  const HeatMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var summary = ref.watch(todosProvider.notifier).summaryPerDay();
    print('summary from heat map is $summary');
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: HeatMapCalendar(
          colorMode: ColorMode.color,
          flexible: true,
          datasets: summary,
          colorsets: {
            0: Colors.red,
            10: Colors.green,
            20: Colors.orange,
            30: Colors.yellow,
            50: Colors.green,
            70: Colors.blue,
            90: Colors.indigo,
            100: Colors.purple,
          },
        ),
      ),
    );
  }
}

//datasert
