import 'package:hive_ce/hive.dart';
import 'package:todos_app_full/models/todo.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<Todo>()])
class HiveAdapters {}
