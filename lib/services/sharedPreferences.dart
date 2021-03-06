import 'package:shared_preferences/shared_preferences.dart';

Future<String> removeSharedPrefKeyValue({String key}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);

  return '$key was removed';
}

Future<String> getSharedPrefKeyValue({String key}) async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString(key);
  if (value == null) {
    return "Empty";
  }
  return value;
}

Future<void> setSharedPrefKeyValue({String key, String value}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value).then((value) async {
    var update = await getSharedPrefKeyValue(key: key);
    print("$key was updated to $update");
  });
}

Future<void> setSharedPrefKeyValueAsList({String key, List<dynamic> value}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(key, value).then((value) {
    print("$key : $value");
    print("$value");
  });
}
