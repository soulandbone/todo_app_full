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
            10: Colors.red,
            20: Colors.green,
            30: Colors.orange,
            40: Colors.yellow,
            50: Colors.green,
            60: Colors.blue,
            70: Colors.indigo,
            80: Colors.purple,
          },
        ),
      ),
    );
  }
}

//datasert
