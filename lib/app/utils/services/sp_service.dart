import 'package:shared_preferences/shared_preferences.dart';

class SpService {
  static SpService? _instance;

  static Future<SpService> get instance async {
    if (_instance == null) {
      _instance = SpService._internal();
      await _instance!._init();
    }
    return _instance!;
  }

  SpService._internal();

  static late final SharedPreferences _prefs;

  Future<void> _init() async => _prefs = await SharedPreferences.getInstance();

  String? getData(String key) {
    if (_prefs.containsKey(key)) {
      return _prefs.getString(key);
    } else {
      return null;
    }
  }

  Future<void> setData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> removeData(String key) async {
    if (_prefs.containsKey(key)) {
      await _prefs.remove(key);
    }
  }

  List<String>? getListData(String key) {
    if (_prefs.containsKey(key)) {
      return _prefs.getStringList(key);
    } else {
      return null;
    }
  }

  Future<void> setListData(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }
}
