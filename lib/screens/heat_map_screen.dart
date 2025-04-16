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
          flexible: true,
          colorMode: ColorMode.color,
          datasets: summary,
          colorsets: {
            0: Colors.red,
            10: Colors.red.withValues(alpha: 0.9),
            20: Colors.red.withValues(alpha: 0.8),
            30: Colors.red.withValues(alpha: 0.7),
            40: Colors.yellow,
            50: Colors.yellow,
            60: Colors.yellow,
            70: Colors.green.withValues(alpha: 0.7),
            80: Colors.green.withValues(alpha: 0.8),
            90: Colors.green.withValues(alpha: 0.9),
            100: Colors.green,
          },
        ),
      ),
    );
  }
}

//datasert
