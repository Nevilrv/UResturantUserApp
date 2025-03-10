import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/info_screen_config.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/InfoScreen/controller/info_controller.dart';
import 'package:urestaurants_user/View/MenuScreen/controller/menu_screen_controller.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/new_order_screen_controller.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/order_screen_controller.dart';

class BottomBarController extends GetxController {
  int selectScreen = 0;
  bool isConnected = false; // Internet connectivity status
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  final InfoController infoController = Get.put(InfoController());
  NewOrderScreenController newOrderScreenController = Get.put(NewOrderScreenController());
  OrderPageController orderPageController = Get.put(OrderPageController());
  MenuPageController menuController = Get.put(MenuPageController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  bool forFirstTime = true;
  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
  }

  void _initializeConnectivity() async {
    _updateConnectionStatus(await _connectivity.checkConnectivity());
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.isNotEmpty) {
      bool olderResult = isConnected;
      isConnected = (result.first == ConnectivityResult.mobile || result.first == ConnectivityResult.wifi);
      bool isFirstTime = preferences.getBool(SharedPreference.isFirstTime, defValue: true) ?? true;
      if ((olderResult != isConnected) && forFirstTime != true) {
        checkDatabaseVersionAndLoadData();
      }
      if (forFirstTime == true) {
        forFirstTime = false;
        checkDatabaseVersionAndLoadData();
      }
    } else {
      isConnected = false;
    }

    log("Internet Connected: \$isConnected");
    update(); // Update UI if needed
  }

  void changeTab(value) {
    selectScreen = value;
    update();
  }

  void onInitMethod(bool isReservation) {
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

  Future<void> checkDatabaseVersionAndLoadData() async {
    menuController.updateLoaderValue(true);
    bool isSame = false;
    bool isFirstTime = preferences.getBool(SharedPreference.isFirstTime, defValue: true) ?? true;
    log('isConnected::::::::::::::::${isConnected}');
    if (isConnected) {
      isSame = await InfoConfig().checkDataVersion();
      log('isSameaaa::::::::::::::::${isSame}');
    } else {
      isSame = isFirstTime == true ? false : true;
      log('isSame::::::::::::::::${isSame}');
      preferences.putBool(SharedPreference.isFirstTime, false);
    }

    log('isSame::::::::::::::::$isSame');
    menuController.fetchData(isDBSame: isSame);
    orderPageController.getData(true, isSame);
    newOrderScreenController.getData(isSame: isSame);
    infoController.initOrder(isDbSame: isSame);
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
