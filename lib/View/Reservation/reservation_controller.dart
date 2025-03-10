import 'package:get/get.dart';

class ReservationController extends GetxController {
  List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
  int selectNumber = 0;
  setSelectedNumber(int value) {
    selectNumber = value;
    update();
  }

  DateTime selectedDate = DateTime.now();
  setSelectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  List<String> timeList = [
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00",
    "20:30",
    "21:00",
  ];
  int selectedSwitch = 0;
  setSwitchIndex(int val) {
    selectedSwitch = val;
    update();
  }
}
