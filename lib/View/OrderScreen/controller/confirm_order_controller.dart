import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/order_config.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/View/InfoScreen/Model/info_data_model.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/new_order_screen_controller.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/order_screen_controller.dart';

class ConfirmOrderController extends GetxController {
  final String userFirstName = preferences.getString(SharedPreference.userFirstName) ?? "";
  final String userLastName = preferences.getString(SharedPreference.userLastName) ?? "";
  final String userId = preferences.getString(SharedPreference.userId) ?? "";
  var uniqueKey = UniqueKey();
  bool isSwitchOn = true;
  int? selectedTimeSlot;
  List<String> slots = [];
  final List<BuyItem> buyItem = Get.arguments;

  toggleSwitch(bool value) {
    HapticFeedBack.buttonClick();
    isSwitchOn = value;
    if (value == true) {
      slots = filterFutureTimeSlots(slots);
      if (slots.isNotEmpty) {
        selectedTimeSlot = 0;
        uniqueKey = UniqueKey();
      }
    }
    update();
  }

  generateSlot() {
    String infoLocalData = preferences.getString(SharedPreference.hotelData) ?? "";
    InfoDataModel infoDataModel = InfoDataModel.fromJson(jsonDecode(infoLocalData));
    String? data = preferences.getString(SharedPreference.exceptionsData);
    Map<String, dynamic> tempData = {};
    if (data != null && data.isNotEmpty) {
      tempData = jsonDecode(data);
    }
    final Map<int, String> weeklyHours = {
      1: infoDataModel.the001Monday ?? "", // Monday
      2: infoDataModel.the002Tuesday ?? "", // Tuesday
      3: infoDataModel.the003Wednesday ?? "", // Wednesday
      4: infoDataModel.the004Thursday ?? "", // Thursday
      5: infoDataModel.the005Friday ?? "", // Friday
      6: infoDataModel.the006Saturday ?? "", // Saturday
      7: infoDataModel.the007Sunday ?? "", // Sunday
    };
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (tempData.containsKey(formattedDate)) {
      String schedule = tempData[formattedDate]['orario'].toString();
      log('weeklyHours::::::::::::::::${weeklyHours}');
      slots = generateTimeSlots(schedule);

      slots = filterFutureTimeSlots(slots);
    } else {
      int weekDay = DateTime.now().weekday;

      String? todaySchedule = weeklyHours[weekDay] ?? "";
      slots = generateTimeSlots(todaySchedule);

      slots = filterFutureTimeSlots(slots);
    }

    log('slots::::::::::::::::$slots');
  }

  List<String> generateTimeSlots(String schedule) {
    List<String> slots = [];
    if (!schedule.contains(":")) {
      return [];
    }

    List<String> timeRanges = schedule.split(" | ");

    for (String range in timeRanges) {
      List<String> times = range.trim().split(" - "); // Trim extra spaces
      if (times.length != 2) continue; // Skip invalid formats

      try {
        DateTime start = DateFormat("HH:mm").parse(times[0].trim());
        DateTime end = DateFormat("HH:mm").parse(times[1].trim());

        DateTime currentTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, start.hour, start.minute);
        DateTime closeTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, end.hour, end.minute);

        while (currentTime.isBefore(closeTime)) {
          slots.add(DateFormat("HH : mm").format(currentTime));
          currentTime = currentTime.add(Duration(minutes: 15));
        }
      } catch (e) {
        return [];
      }
    }

    return slots;
  }

  List<String> filterFutureTimeSlots(List<String> timeSlots) {
    DateTime now = DateTime.now();
    DateTime currentTime = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    List<String> filteredSlots = timeSlots.where((slot) {
      DateTime slotTime = DateFormat("HH : mm").parse(slot);
      DateTime slotDateTime = DateTime(now.year, now.month, now.day, slotTime.hour, slotTime.minute);

      return slotDateTime.isAfter(currentTime); // Keep only future times
    }).toList();

    return filteredSlots;
  }

  updateTime(int index) async {
    selectedTimeSlot = index;
    update();
    if (isSwitchOn) {
      isSwitchOn = false;
      update();
      // await Future.delayed(const Duration(seconds: 3));
      // slots = filterFutureTimeSlots(slots);
      // if (slots.isNotEmpty) {
      //   selectedTimeSlot = 0;
      //   uniqueKey = UniqueKey();
      // }
    }
    update();
  }

  Map<String, dynamic> makeBody() {
    Map<String, dynamic> body = {};
    String? slot = selectedTimeSlot != null ? slots[selectedTimeSlot!] : "";
    Map<String, dynamic> details = {"0": "Take Away | $slot"};
    int lastDetailIndex = 1;
    int itemCount = 0;
    String orderCod = "";

    String userId = preferences.getString(SharedPreference.userId) ?? "";
    String userLastName = preferences.getString(SharedPreference.userLastName) ?? "";
    for (int mainItemIndex = 0; mainItemIndex < buyItem.length; mainItemIndex++) {
      BuyItem mainItem = buyItem[mainItemIndex];
      if (mainItem.itemType == ItemType.normal) {
        details.addAll({"$lastDetailIndex": "${mainItem.qty} x ${mainItem.name} €${mainItem.amount}"});
        orderCod += "|D.${mainItem.cod}";
        lastDetailIndex++;
        itemCount++;
      }

      for (int subItemIndex = 0; subItemIndex < mainItem.subItem.length; subItemIndex++) {
        BuyItem subItem = mainItem.subItem[subItemIndex];

        if (subItem.isMainItem) {
          details.addAll({"$lastDetailIndex": "${subItem.qty} x ${subItem.name} €${subItem.amount}"});
          lastDetailIndex++;
          itemCount++;
          orderCod += "|D.${subItem.cod}";
        } else {
          if (subItem.itemType == ItemType.addVariants) {
            details.addAll({"$lastDetailIndex": "+ ${subItem.name} €${subItem.amount}"});
            lastDetailIndex++;
            itemCount++;
            orderCod += "|V+${subItem.cod}";
          } else if (subItem.itemType == ItemType.subtractedVariants) {
            details.addAll({"$lastDetailIndex": "- ${subItem.name}"});
            lastDetailIndex++;
            itemCount++;
            orderCod += "|Vm.${subItem.cod}";
          }
        }
      }
    }

    details.addAll({"Count": itemCount});

    body.addAll({
      "Cod": ("$itemCount-$orderCod#NV2£$userId?$userLastName/${slot}"),
      "Data": DateFormat('yyyy/MM/dd').format(DateTime.now()),
      "Dittaglio": details,
      "Ora": slot,
    });
    return body;
  }

  Future<void> storeOrderData() async {
    HapticFeedBack.buttonClick();
    Map<String, dynamic> body = makeBody();
    log('body::::::::::::::::${body}');
    log('userId::::::::::::::::${userId}');
    final bool result = await OrderConfig().storeOrderData(userId, body);
    if (result) {
      Get.find<OrderPageController>().getData(false);
      Get.back();
      Get.back();
      Get.back();
    } else {}
  }

  String formatDuration(DateTime duration) {
    int hours = duration.hour;
    int minutes = duration.minute.remainder(60);
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
  }
}
