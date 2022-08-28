import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<bool> getCurrent() async {
    final pref = await SharedPreferences.getInstance();
    bool tmp = pref.getBool('darkTheme')!;
    return tmp;
  }

  static Future<void> init() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('darkTheme', false);
  }

  static Future<void> change() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('darkTheme', !pref.getBool('darkTheme')!);
  }
}
