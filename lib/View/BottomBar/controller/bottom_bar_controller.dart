import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/InfoScreen/controller/info_controller.dart';
import 'package:urestaurants_user/View/MenuScreen/controller/menu_screen_controller.dart';
import 'package:urestaurants_user/View/Reservation/reservation_controller.dart';

class BottomBarController extends GetxController {
  int selectScreen = 0;
  bool isConnected = false; // Internet connectivity status
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  final InfoController infoController = Get.put(InfoController());

  MenuPageController menuPageController = Get.put(MenuPageController());
  ReservationController reservationController = Get.put(ReservationController());

  bool forFirstTime = true;
  bool isReservationAvailable = false;
  @override
  void onInit() {
    super.onInit();
    fetchReservationData();
    _initializeConnectivity();
  }

  fetchReservationData() async {
    await reservationController.fetchReservationData(
      (p0) {
        log('p0::::::::::::::::${p0}');
        isReservationAvailable = p0;
        update();
      },
    );
  }

  void _initializeConnectivity() async {
    _updateConnectionStatus(await _connectivity.checkConnectivity());
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
    homeScreenController.getInitialData();
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    bool olderResult = isConnected;
    if (result.isNotEmpty) {
      isConnected = (result.first == ConnectivityResult.mobile || result.first == ConnectivityResult.wifi);
      if (isConnected == true && selectScreen == 2 && isReservationAvailable == true) {
        fetchReservationData();
      }
    } else {
      isConnected = false;
    }
    if (olderResult == false && ((preferences.getString(SharedPreference.allData, defValue: '') ?? '').isEmpty)) {
      homeScreenController.getInitialData();
    }

    log("Internet Connected: \$isConnected");
    update(); // Update UI if needed
  }

  void changeTab(value) {
    selectScreen = value;
    update();
  }

  Future<void> checkDatabaseVersionAndLoadData() async {
    // bool isSame = false;
    // bool isFirstTime = preferences.getBool(SharedPreference.isFirstTime, defValue: true) ?? true;
    // log('isConnected::::::::::::::::${isConnected}');
    // if (isConnected) {
    //   isSame = await InfoConfig().checkDataVersion();
    //   log('isSameaaa::::::::::::::::${isSame}');
    // } else {
    //   isSame = isFirstTime == true ? false : true;
    //   log('isSame::::::::::::::::${isSame}');
    //   preferences.putBool(SharedPreference.isFirstTime, false);
    // }
    //
    // log('isSame::::::::::::::::$isSame');
    //
    // orderPageController.getData(true, isSame);
    // newOrderScreenController.getData(isSame: isSame);
    // infoController.initOrder(isDbSame: isSame);
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
