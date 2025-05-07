import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/providers/todos_provider.dart';

final summaryProvider = Provider<Map<DateTime, int>>((ref) {
  final todos = ref.watch(todosProvider);
  return helpers.computeSummaryFromTodos(todos);
});
