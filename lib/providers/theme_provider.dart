import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_app_full/models/theme_settings.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  final themeSettings = ThemeSettings(); //instance of the class
  return ThemeNotifier(themeSettings);
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier(this.themeSettings)
    : super(themeSettings.isDarkMode!); // initial value is recovered from Hive.
  final ThemeSettings themeSettings;

  void updateTheme(bool value) {
    state = value; //update state
    themeSettings.setDarkMode(value); //save it to Hive
  }
}
