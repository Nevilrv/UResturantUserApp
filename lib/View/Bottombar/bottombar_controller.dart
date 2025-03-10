import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';

class BottomBarController extends GetxController {
  int selectScreen = 0;

  changeTab(value) {
    selectScreen = value;
    update();
  }

  onInitMethod(bool isReservation) {
    String lastPage = preferences.getString(SharedPreference.currentPage) ?? "";

    if (!isReservation) {
      if (lastPage == "info") {
        changeTab(1);
      } else {
        changeTab(0);
      }
    } else {
      if (lastPage == "reservation") {
        changeTab(1);
      } else if (lastPage == "info") {
        changeTab(2);
      } else {
        changeTab(0);
      }
    }
  }
}
