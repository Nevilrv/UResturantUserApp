import 'dart:convert';

import 'package:get/get.dart';
import 'package:urestaurants_user/FirebaseConfig/restaurent_config.dart';
import 'package:urestaurants_user/Utils/sql_helper.dart';
import 'package:urestaurants_user/View/BottomBar/controller/bottom_bar_controller.dart';
import 'package:urestaurants_user/View/InfoScreen/Model/info_data_model.dart';
import 'package:urestaurants_user/View/InfoScreen/controller/info_controller.dart';
import 'package:urestaurants_user/View/MenuScreen/Model/item_data_model.dart';
import 'package:urestaurants_user/View/MenuScreen/controller/menu_screen_controller.dart';

import '../model/all_data_model.dart';

class HomeScreenController extends GetxController {
  List<AllDataModel> allData = [];
  List<AllDataModel> restaurantsData = [];
  List<AllDataModel> pizzeriasData = [];
  List<AllDataModel> trattoriasData = [];
  Set<String> cityFilter = {};
  Set<String> typeFilter = {};
  AllDataModel? selectedRestaurant;
  String selectedCity = "All";
  List<Map<String, dynamic>> appliedFilters = [];
  List<int> selectedTypeFilters = [];

  updateSelectedTypeFilters(int index) {
    if (selectedTypeFilters.contains(index)) {
      selectedTypeFilters.remove(index);
    } else {
      selectedTypeFilters.add(index);
    }
  }

  addFilter(String value, String type) {
    appliedFilters.add({"type": type, "value": value});

    update();
  }

  removeFilter(String value, String type) {
    appliedFilters.removeWhere(
      (element) => element['type'] == type && element['value'] == value,
    );
    update();
  }

  updateSelectedCity(String value) {
    selectedCity = value;
    update();
  }

  updateSelectedRestaurant(AllDataModel data) {
    selectedRestaurant = data;
    Get.find<MenuPageController>().fetchSectionData();
    Get.find<InfoController>().initOrder();
    Get.find<BottomBarController>().fetchReservationData();
    update();
  }

  bool isLoading = false;

  getInitialData() async {
    allData.clear();
    restaurantsData.clear();
    pizzeriasData.clear();
    trattoriasData.clear();
    isLoading = true;
    update();
    List<Map<String, dynamic>> localData = await DatabaseHelper().getAllTableData(tableName: DatabaseHelper.restaurant);
    List<LocalRestaurant> localRestaurantData = List<LocalRestaurant>.from(localData.map((e) => LocalRestaurant.fromJson(e)));
    if (localData.isNotEmpty) {
      for (int index = 0; index < localRestaurantData.length; index++) {
        Map<String, dynamic> config = jsonDecode(localRestaurantData[index].config);
        Map<String, dynamic>? exception = jsonDecode(localRestaurantData[index].exception ?? "");
        Map<String, dynamic> info = jsonDecode(localRestaurantData[index].info);
        List items = jsonDecode(localRestaurantData[index].items) as List;
        allData.add(
          AllDataModel(
            config: Config.fromJson(config),
            exceptions: exception,
            info: InfoDataModel.fromJson(info),
            items: List<ItemDataModel>.from(items.map((e) => ItemDataModel.fromJson(e as Map<String, dynamic>))),
            id: localRestaurantData[index].id,
            fullAddress: localRestaurantData[index].fullAddress,
            lat: double.tryParse(localRestaurantData[index].lat) ?? 0.0,
            long: double.tryParse(localRestaurantData[index].lang) ?? 0.0,
          ),
        );
      }
      getDataFromClaud();
    } else {
      await getDataFromClaud();
    }
    filterTypeWise();

    isLoading = false;
    selectedRestaurant = allData.firstWhere(
      (element) => element.id == "01",
    );
    update();
    Get.find<MenuPageController>().fetchSectionData();
    Get.find<InfoController>().initOrder();
  }

  getDataFromClaud() async {
    if (Get.find<BottomBarController>().isConnected) {
      allData = await RestaurentConfig().getData();
      if (allData.isNotEmpty) {
        filterTypeWise();
      }
    }
    update();
  }

  void filterTypeWise({List<AllDataModel>? data}) {
    restaurantsData.clear();
    pizzeriasData.clear();
    trattoriasData.clear();
    cityFilter.clear();
    cityFilter.add("All");

    for (var item in (data ?? allData)) {
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
      if (data == null) {
        // Add unique cities using a Set
        if (item.info?.city?.isNotEmpty ?? false) {
          cityFilter.add(item.info!.city!);
        }
        if (item.info?.atr1?.isNotEmpty ?? false) {
          typeFilter.add(item.info!.atr1!);
        }
        if (item.info?.atr2?.isNotEmpty ?? false) {
          typeFilter.add(item.info!.atr2!);
        }
      }
    }
  }

  List<AllDataModel> filteredData = [];

  applyFilter() {
    filteredData = [];
    restaurantsData.clear();
    pizzeriasData.clear();
    trattoriasData.clear();

    if (appliedFilters.isEmpty) {
      filterTypeWise();
    }

    if (appliedFilters.any(
      (element) => element['type'] == "City",
    )) {
      int index = appliedFilters.indexWhere(
        (element) => element['type'] == "City",
      );
      String cityName = appliedFilters[index]['value'];
      for (var item in allData) {
        if (item.info?.city == cityName || cityName == "All") {
          filteredData.add(item);
        }
      }
      appliedFilters.removeAt(index);
    }

    List<AllDataModel> data = filteredData.isEmpty ? allData : filteredData;
    for (var element in appliedFilters) {
      customFilter(element['value'], element['type'], data);
    }

    filterTypeWise(data: appliedFilters.isEmpty ? null : filteredData);
    update();
  }

  void customFilter(String name, String type, List<AllDataModel> data) {
    if (type == "City") {
    } else if (type == "Type") {
      for (var item in data) {
        if (item.info?.atr1 == name || item.info?.atr2 == name) {
          filteredData.add(item);
        }
      }
    }
  }
}

class LocalRestaurant {
  int? autoId;
  String id;
  String config;
  String items;
  String info;
  String? exception;
  String lat;
  String lang;
  String fullAddress;
  String? image;

  LocalRestaurant({
    this.autoId,
    required this.id,
    required this.config,
    required this.items,
    required this.info,
    this.exception,
    required this.lat,
    required this.lang,
    required this.fullAddress,
    this.image,
  });

  factory LocalRestaurant.fromMap(Map<String, dynamic> map) {
    return LocalRestaurant(
      autoId: map['auto_id'],
      id: map['id'],
      config: map['config'],
      items: map['items'],
      info: map['info'],
      exception: map['exception'],
      lat: map['lat'],
      lang: map['lang'],
      fullAddress: map['fulladdress'],
      image: map['image'],
    );
  }

  // Convert from a Restaurant Object to a Map (For Database Insertion)
  Map<String, dynamic> toMap() {
    return {
      'auto_id': autoId,
      'id': id,
      'config': config,
      'items': items,
      'info': info,
      'exception': exception,
      'lat': lat,
      'lang': lang,
      'fulladdress': fullAddress,
      'image': image,
    };
  }

  // Convert from JSON to Object
  factory LocalRestaurant.fromJson(Map<String, dynamic> json) {
    return LocalRestaurant(
      autoId: json['auto_id'],
      id: json['id'],
      config: json['config'],
      items: json['items'],
      info: json['info'],
      exception: json['exception'],
      lat: json['lat'],
      lang: json['lang'],
      fullAddress: json['fulladdress'],
      image: json['image'],
    );
  }

  // Convert Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'auto_id': autoId,
      'id': id,
      'config': config,
      'items': items,
      'info': info,
      'exception': exception,
      'lat': lat,
      'lang': lang,
      'fulladdress': fullAddress,
      'image': image,
    };
  }
}
