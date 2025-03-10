import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/order_config.dart';

import '../models/order_model.dart';

class OrderPageController extends GetxController {
  List<Order> order = [];
  bool isLoading = false;

  getData([bool? isShowLoading = true, bool? isSame = false]) async {
    bool? isLogin = preferences.getBool(SharedPreference.isLogin);
    String? dataString = preferences.getString(SharedPreference.orderData);

    if (isLogin == true) {
      if (isSame == true && dataString != null && dataString.isNotEmpty) {
        getDataFromLocal(dataString);
      } else {
        if (isShowLoading == true) {
          isLoading = true;
          update();
        }
        List<Map<String, dynamic>> data = await OrderConfig().getOrderData();
        log('data::::::::::::::::${data}');
        await preferences.putString(SharedPreference.orderData, jsonEncode(data));
        order = List<Order>.from(data.map(
          (e) => Order.fromJson(e),
        ));
        isLoading = false;
        update();
      }
    }

    isLoading = false;
    update();
  }

  getDataFromLocal(String? dataString) async {
    if (dataString != null && dataString.isNotEmpty) {
      List<Map<String, dynamic>> data = jsonDecode(dataString);
      log('data::::::::::::::::${data}');
      await preferences.putString(SharedPreference.orderData, jsonEncode(data));
      order = List<Order>.from(data.map(
        (e) => Order.fromJson(e),
      ));
    }

    update();
  }
}
