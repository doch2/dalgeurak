import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {

  static final SharedPreference _instance = SharedPreference._privateConstructor();
  factory SharedPreference() {
    return _instance;
  }

  late SharedPreferences _prefInstance;
  SharedPreference._privateConstructor() {
    SharedPreferences.getInstance().then((prefs) {
      _prefInstance = prefs;
    });
  }


  getMealPlanner() => _prefInstance.getString("mealPlanner");

  saveMealPlanner(Map data) async => await _prefInstance.setString("mealPlanner", json.encode(data));

  getAllowAlert() => _prefInstance.getBool("allowAlert");

  saveAllowAlert(bool isAllow) async => await _prefInstance.setBool("allowAlert", isAllow);
}
