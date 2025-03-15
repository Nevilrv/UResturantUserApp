import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/reservation_config.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/Reservation/Model/reservation_model.dart';

class ReservationController extends GetxController {
  bool fetchDataLoader = false;
  ReservationModel? reservationModel;
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
  int? selectedTableNumber;
  String? selectedTime;
  DateTime selectedDate = DateTime.now();
  int selectedSwitch = 0;
  String? people;
  Map<String, int>? todaySlotTime;
  List<String> timeList = [];
  List<int> slotList = [];
  TextEditingController requestController = TextEditingController();

  clearData(bool isUpdate) {
    selectedTableNumber = null;
    selectedTime = null;
    selectedDate = DateTime.now();
    selectedSwitch = 0;
    people = null;
    requestController.clear();
    if (isUpdate) {
      update();
    }
  }

  Future<void> fetchReservationData(dynamic Function(bool)? isActive) async {
    fetchDataLoader = true;
    update();
    try {
      final snapshot = await ReservationConfig(
        isActive: isActive,
      ).reservationData(Get.find<HomeScreenController>().selectedRestaurant?.id ?? "01");
      if (snapshot != null) {
        reservationModel = ReservationModel.fromJson(json.decode(jsonEncode(snapshot)));
        if (reservationModel?.disponibilit != null) {
          todaySlotTime = fetchTodaySchedule(reservationModel!.disponibilit!);
          timeList = todaySlotTime!.keys.toList();
          slotList = todaySlotTime!.values.toList();
        }
      }
    } catch (e) {
      debugPrint('e==========>>>>>$e');
    }
    fetchDataLoader = false;
    update();
  }

  addBookingOnDatabase() async {
    String firstName = preferences.getString(SharedPreference.userFirstName) ?? "";
    String lastName = preferences.getString(SharedPreference.userLastName) ?? "";
    Map<String, dynamic> body = {
      "Email": preferences.getString(SharedPreference.userEmail) ?? "",
      "Giorno": DateFormat("dd MMMM yyyy").format(selectedDate),
      "Ora": selectedTime,
      "Pax": people,
      "Place": Get.find<HomeScreenController>().selectedRestaurant?.info?.nome,
      "Request": requestController.text.trim(),
      "Status": "Confermata"
    };
    Map<String, dynamic> body1 = {
      "Cognome": lastName,
      "Ora": selectedTime,
      "Pax": people,
      "Request": requestController.text.trim(),
      "Status": "Confermata"
    };
    String id = "${DateFormat("dd MMMM yyyy").format(selectedDate)} | $selectedTime";
    const String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String prefix = '!';
    final math.Random random = math.Random();
    String randomPart = List.generate(5, (_) => characters[random.nextInt(characters.length)]).join();
    String randomString = "$prefix$randomPart";
    String id1 = (firstName.isEmpty ? "" : ("$firstName ")) + (lastName.isEmpty ? "" : ("$lastName ")) + randomString;
    await ReservationConfig().addBookingDataIntoUserProfile(time: id, body: body);
    await ReservationConfig().addBookingDataIntoReservation(
      id1: id1,
      body: body1,
      day: selectedDate.day.toString().padLeft(2, "0"),
      month: selectedDate.month.toString().padLeft(2, "0"),
      year: selectedDate.year.toString(),
    );
  }

  setSelectedNumber(int value) {
    selectedTableNumber = value;
    people = "$selectedTableNumber Adulti";
    if (selectedSwitch == 0) {
      people = "$selectedTableNumber Adulti";
    } else if (selectedSwitch == 1) {
      people = "${selectedTableNumber! - selectedSwitch} Adulti & $selectedSwitch Bambino";
    } else {
      people = "${selectedTableNumber! - selectedSwitch} Adulti & $selectedSwitch Bambini";
    }
    update();
  }

  setSelectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  setSelectedTime(String time) {
    selectedTime = time;
    update();
  }

  setSwitchIndex(int val) {
    selectedSwitch = val;
    if (val == 0) {
      people = "$selectedTableNumber Adulti";
    } else if (val == 1) {
      people = "${selectedTableNumber! - val} Adulti & $val Bambino";
    } else {
      people = "${selectedTableNumber! - val} Adulti & $val Bambini";
    }
    update();
  }

  Map<String, int>? fetchTodaySchedule(Disponibilit disponibilit) {
    DateTime now = DateTime.now();
    String todayName = DateFormat('EEEE').format(now);
    Map<String, int>? todaySchedule;
    switch (todayName) {
      case "Friday":
        todaySchedule = disponibilit.friday;
        break;
      case "Monday":
        todaySchedule = disponibilit.monday;
        break;
      case "Saturday":
        todaySchedule = disponibilit.saturday;
        break;
      case "Sunday":
        todaySchedule = disponibilit.sunday;
        break;
      case "Thursday":
        todaySchedule = disponibilit.thursday;
        break;
      case "Tuesday":
        todaySchedule = disponibilit.tuesday;
        break;
      case "Wednesday":
        todaySchedule = disponibilit.wednesday;
        break;
    }
    return todaySchedule;
  }
}
