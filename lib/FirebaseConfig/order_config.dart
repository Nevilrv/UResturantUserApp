import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';

class OrderConfig {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<bool> storeOrderData(String? userId, Map<String, dynamic> body) async {
    try {
      int totalOrders = 0;

      DatabaseReference configRef = _databaseRef.child(userId ?? "");
      //'HWtvHGVmXded5Hqh04dFYrFxflr2'
      final snapshot = await configRef.get();

      if (snapshot.exists) {
        Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));
        if (data.containsKey("0rders")) {
          totalOrders = data['0rders'];
        }

        List<int> numericKeys = data.keys
            .where((key) => int.tryParse(key) != null) // Keep only numeric keys
            .map((key) => int.parse(key)) // Convert to int
            .toList();

        int lastIndex = numericKeys.isNotEmpty ? numericKeys.reduce((a, b) => a > b ? a : b) : 0;

        await _databaseRef.child(userId ?? "").update({"0rders": totalOrders + 1, "${lastIndex + 1}": body});
        return true;
      }
    } catch (e) {
      log('e=====userData=====>>>>>$e');
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getOrderData() async {
    try {
      String userId = preferences.getString(SharedPreference.userId) ?? "";
      int totalOrders = 0;
      DatabaseReference configRef = _databaseRef.child(userId ?? "");
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));
        if (data.containsKey("0rders")) {
          totalOrders = data['0rders'];
        }
        List<int> numericKeys = data.keys
            .where((key) => int.tryParse(key) != null) // Keep only numeric keys
            .map((key) => int.parse(key)) // Convert to int
            .toList();
        numericKeys.sort();

        List<Map<String, dynamic>> res = [];
        numericKeys.forEach(
          (element) {
            res.add(data[element.toString()]);
          },
        );
        return res;
      }
    } catch (e) {
      log('e=====userData=====>>>>>$e');
    }
    return [];
  }
}
