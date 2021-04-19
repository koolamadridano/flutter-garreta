import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> _getCustomerIdInLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString('customerId');
  if (value == null) {
    return "Empty";
  }
  return value;
}

Future<void> _setCustomerIdInLocal({@required String value}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('customerId', value);
}
