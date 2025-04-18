import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:todos_app_full/hive_boxes.dart';

class ThemeSettings {
  final Box<bool> _box = Hive.box<bool>(themeBox);

  void setDarkMode(bool isDarkMode) {
    _box.put('isDarkMode', isDarkMode);
  }

  bool? get isDarkMode {
    return _box.get('isDarkMode', defaultValue: false);
  }
}
