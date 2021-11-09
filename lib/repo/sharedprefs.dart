import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static getData() async {
    var prefs = await SharedPreferences.getInstance();

    var counter = prefs.getInt('counter');

    return counter;
  }

  static saveData(counter) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', counter);
  }

  static getactivations() async {
    var prefs = await SharedPreferences.getInstance();

    var activation = prefs.getBool('activate');

    return activation;
  }

  static activateData(status) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('activate', status);
  }
}
