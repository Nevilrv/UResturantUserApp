import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/restaurent_config.dart';
import 'package:urestaurants_user/View/BottomBar/controller/bottom_bar_controller.dart';
import 'package:urestaurants_user/View/InfoScreen/controller/info_controller.dart';
import 'package:urestaurants_user/View/MenuScreen/controller/menu_screen_controller.dart';

import '../model/all_data_model.dart';

class HomeScreenController extends GetxController {
  List<AllDataModel> allData = [];
  List<AllDataModel> restaurantsData = [];
  List<AllDataModel> pizzeriasData = [];
  List<AllDataModel> trattoriasData = [];
  AllDataModel? selectedRestaurant;

  updateSelectedRestaurant(AllDataModel data) {
    selectedRestaurant = data;
    Get.find<MenuPageController>().fetchSectionData();
    Get.find<InfoController>().initOrder();
    Get.find<BottomBarController>().fetchReservationData();
    update();
  }

  bool isLoading = false;

  getInitialData() async {
    allData = [];

    isLoading = true;
    update();
    String localData = preferences.getString(SharedPreference.allData, defValue: '') ?? '';
    log('Get.find<BottomBarController>().isConnected::::::::::::::::${Get.find<BottomBarController>().isConnected}');

    if (localData.isNotEmpty) {
      List data = jsonDecode(localData);
      allData = List<AllDataModel>.from(data.map(
        (e) {
          log('e::::::::::::::::${e}');
          return AllDataModel.fromJson(e, e['id']);
        },
      ));
      getDataFromClaud();
    } else {
      await getDataFromClaud();
    }
    log('allData:1111:::::::::::::::${allData.length}');
    filterTypeWise();

    isLoading = false;
    selectedRestaurant = allData.firstWhere(
      (element) => element.id == "01",
    );

    Get.find<MenuPageController>().fetchSectionData();
    Get.find<InfoController>().initOrder();
    update();
  }

  getDataFromClaud() async {
    if (Get.find<BottomBarController>().isConnected) {
      allData = await RestaurentConfig().getData();
    }
    log('allData::::::::::::::::${allData}');
    if (allData.isNotEmpty) {
      await preferences.putString(SharedPreference.allData, jsonEncode(allData));
      await filterTypeWise();
    }
    update();
  }

  filterTypeWise() {
    restaurantsData = [];
    pizzeriasData = [];
    trattoriasData = [];
    restaurantsData.addAll(allData
        .where(
          (element) => element.info?.mode == "Ristorante",
        )
        .toList());
    pizzeriasData.addAll(allData
        .where(
          (element) => element.info?.mode == "Pizza",
        )
        .toList());
    trattoriasData.addAll(allData
        .where(
          (element) => element.info?.mode == "Trattoria",
        )
        .toList());
  }
}
