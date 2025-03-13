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
  Set<String> cityFilter = {};
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
      filterTypeWise();
    }
    update();
  }

  void filterTypeWise() {
    // Clear previous data
    restaurantsData.clear();
    pizzeriasData.clear();
    trattoriasData.clear();
    cityFilter.clear();
    cityFilter.add("All");
    // Use a single loop to filter types & extract cities
    for (var item in allData) {
      switch (item.info?.mode) {
        case "Ristorante":
          restaurantsData.add(item);
          break;
        case "Pizza":
          pizzeriasData.add(item);
          break;
        case "Trattoria":
          trattoriasData.add(item);
          break;
      }

      // Add unique cities using a Set
      if (item.info?.city?.isNotEmpty ?? false) {
        cityFilter.add(item.info!.city!);
      }
    }
  }

  void customFilter(String name, String type) {
    restaurantsData.clear();
    pizzeriasData.clear();
    trattoriasData.clear();
    if (type == "City") {
      for (var item in allData) {
        if (item.info?.city == "$name") {
          switch (item.info?.mode) {
            case "Ristorante":
              restaurantsData.add(item);
              break;
            case "Pizza":
              pizzeriasData.add(item);
              break;
            case "Trattoria":
              trattoriasData.add(item);
              break;
          }
        }
      }
    }
  }
}
