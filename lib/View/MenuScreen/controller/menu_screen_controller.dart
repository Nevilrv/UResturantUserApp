import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_string.dart';
import 'package:urestaurants_user/Utils/sql_helper.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/MenuScreen/Model/item_data_model.dart';
import 'package:urestaurants_user/View/MenuScreen/Model/section_data_model.dart';

class MenuPageController extends GetxController {
  bool isTapped = false;
  TextEditingController textController = TextEditingController();
  List<int> selectedIndex = [];
  List<String> allergyImageList = [];
  int selectedIndex2 = 0;
  int selectedIndex1 = -1;
  Set<String> selectedItems = {};
  List<SectionDataModel>? sectionDataModel;
  List<ItemDataModel> itemDataModel = [];
  bool fetchDataLoader = false;
  String message = "";

  // String currentLanguage = html.window.navigator.language.split('-').first;
  String currentLanguage = "it";
  List<Map<String, dynamic>> filterList = [];
  List<Map<String, dynamic>> mainData = [];
  String selectedCategory = "";
  List<Map<String, dynamic>> allergies = [
    {"title": "A", "image": "glutine.png"},
    {"title": "B", "image": "crostacei.png"},
    {"title": "M", "image": "sesamo.png"},
    {"title": "H", "image": "noci.png"},
    {"title": "C", "image": "uovo.png"},
    {"title": "D", "image": "pesce.png"},
    {"title": "P", "image": "molluschi.png"},
    {"title": "L", "image": "senape.png"},
    {"title": "I", "image": "sedano.png"},
    {"title": "E", "image": "arachidi.png"},
    {"title": "G", "image": "latte.png"},
    {"title": "N", "image": "solfiti.png"},
    {"title": "F", "image": "soia.png"},
    {"title": "O", "image": "lupini.png"},
  ];

  List<Map<String, String>> allLanguage = [
    {"name": "Italiano", "image": "assets/images/Italy.png", "code": "it"},
    {"name": "Inglese", "image": "assets/images/uk.png", "code": "en"},
    {"name": "Francese", "image": "assets/images/France.png", "code": "fr"},
    {"name": "Tedesco", "image": "assets/images/Germany.png", "code": "de"},
    {"name": "Russo", "image": "assets/images/Russia.png", "code": "ru"},
    {"name": "Cinese", "image": "assets/images/china.png", "code": "zh-Hans"},
    {"name": "Polacco", "image": "assets/images/polish.png", "code": "pl"},
  ];

  updateLanguage(String code) {
    currentLanguage = code;
    update();
  }

  updateLoaderValue(bool value) {
    fetchDataLoader = value;
    update();
  }

  Future<void> fetchSectionData() async {
    try {
      fetchDataLoader = true;
      update();

      filterList = [];
      List<SectionDataModel>? decodedData = Get.find<HomeScreenController>().selectedRestaurant?.config?.sections ?? [];
      List<Map<String, dynamic>> sectionImages = await DatabaseHelper().getAllTableData(
        tableName: DatabaseHelper.section,
      );
      Map<String, dynamic> images = {};

      for (int i = 0; i < sectionImages.length; i++) {
        var e = sectionImages[i];
        images.addAll({"${e['section']}": "${e['image']}"});
      }

      for (var element in decodedData) {
        List<String> subCategory = element.subCategory ?? [];
        element.imageUrl = images['${element.name}'] ?? "";
        filterList.add({"${element.name}": "$subCategory"});
      }

      sectionDataModel = decodedData;

      selectedCategory = sectionDataModel?.first.name ?? "";
      await fetchItemData();
    } catch (e) {
      log('e=====fetchSectionData=====>>>>>$e');
    }
    fetchDataLoader = false;
    update();
  }

  Future<void> fetchItemData() async {
    try {
      List<ItemDataModel> snapshot = Get.find<HomeScreenController>().selectedRestaurant?.items ?? [];
      itemDataModel.clear();

      if (snapshot.isNotEmpty) {
        itemDataModel = snapshot;

        await filterItemData();
      } else {
        message = "No Items!";
      }
    } catch (e) {
      log('e=====fetchItemData=====>>>>>$e');
    }
    update();
  }

  Future<void> filterItemData() async {
    message = "";
    mainData = [];
    update();
    for (var section in filterList) {
      Map sectionData = jsonDecode(jsonEncode(section));

      sectionData.forEach((key, value) {
        if (key == selectedCategory) {
          List<String> valueList = value.toString().replaceAll("[", "").replaceAll("]", "").split(", ").toList();
          for (var subCategory in valueList) {
            List<ItemDataModel>? matchingItems = itemDataModel.where((item) {
              bool isMatchingSubCategory = item.subCategory == subCategory || item.subCategory == null;
              return item.sezione == selectedCategory && isMatchingSubCategory;
            }).toList();
            if (matchingItems.isNotEmpty) {
              mainData.add({
                "title": subCategory,
                "data": matchingItems,
              });
            }
          }
        }
      });
    }

    if (mainData.isEmpty) {
      message = "No Items!";
    }
  }

  void updateSelectedIndex(
    List<int> value,
    String ell,
  ) {
    allergyImageList = [];

    /// COLOR CHANGE

    selectedIndex = value;

    /// FIND ALLERGIES IMAGES

    for (var i = 0; i < ell.length; i++) {
      List<Map<String, dynamic>> image = allergies.where((element) => element["title"] == ell[i]).toList();
      if (image.isNotEmpty) {
        allergyImageList.add(image.first["image"]);
      }
    }
    update();
  }

  Future<void> updateMenuName(value) async {
    allergyImageList = [];
    selectedIndex = [];
    selectedIndex2 = value;
    selectedCategory = sectionDataModel?[value].name ?? "";
    await filterItemData();
    update();
  }

  String getHeader(int index) {
    switch (currentLanguage) {
      case 'ru':
        return "${sectionDataModel?[index].nameRu ?? sectionDataModel?[index].name}";
      case 'de':
        return "${sectionDataModel?[index].nameDe ?? sectionDataModel?[index].name}";
      case 'en':
        return "${sectionDataModel?[index].nameEn ?? sectionDataModel?[index].name}";
      case 'es':
        return "${sectionDataModel?[index].nameEs}";
      case 'fr':
        return "${sectionDataModel?[index].nameFr}";
      case 'pl':
        return "${sectionDataModel?[index].namePl}";
      case 'zh':
        return "${sectionDataModel?[index].nameZh}";
      case 'zh-Hans':
        return "${sectionDataModel?[index].nameZhHans}";
      case 'it':
        return "${sectionDataModel?[index].name}";
      default:
        return "${sectionDataModel?[index].nameEn ?? sectionDataModel?[index].name}";
    }
  }

  String getTitle(int index, int itemIndex, {String? local}) {
    ItemDataModel data = mainData[index]["data"][itemIndex];
    switch (local ?? currentLanguage) {
      case 'ru':
        return "${data.the000NomeRu ?? data.the000Nome}";
      case 'de':
        return "${data.the000NomeDe ?? data.the000Nome}";
      case 'en':
        return "${data.the000NomeEn ?? data.the000Nome}";
      case 'es':
        return "${data.the000NomeEs ?? data.the000Nome}";
      case 'fr':
        return "${data.the000NomeFr ?? data.the000Nome}";
      case 'pl':
        return "${data.the000NomePl ?? data.the000Nome}";
      case 'zh':
        return "${data.the000NomeZh ?? data.the000Nome}";
      case 'zh-Hans':
        return "${data.the000NomeZhHans ?? data.the000Nome}";
      case 'it':
        return "${data.the000Nome} ";
      default:
        return "${data.the000NomeEn}";
    }
  }

  String getSubTitle(int index, int itemIndex, {String? local}) {
    ItemDataModel data = mainData[index]["data"][itemIndex];
    switch (local ?? currentLanguage) {
      case 'ru':
        return "${data.ingredientiRu ?? data.ingredienti}";
      case 'de':
        return "${data.ingredientiDe ?? data.ingredienti}";
      case 'en':
        return "${data.ingredientiEn ?? data.ingredienti}";
      case 'es':
        return "${data.ingredientiEs ?? data.ingredienti}";
      case 'fr':
        return "${data.ingredientiFr ?? data.ingredienti}";
      case 'pl':
        return "${data.ingredientiPl ?? data.ingredienti}";
      case 'zh':
        return "${data.ingredientiZh ?? data.ingredienti}";
      case 'zh-Hans':
        return "${data.ingredientiZhHans ?? data.ingredienti}";
      case 'it':
        return "${data.ingredienti ?? data.ingredienti}";
      default:
        return "${data.ingredientiEn ?? data.ingredienti}";
    }
  }

  List<String> countryRs = [
    AppString.euro,
    AppString.usDollar,
    AppString.ukPound,
    AppString.polishZloty,
    AppString.chineseYuan,
  ];
  List<String> map = [
    AppAssets.uk,
    AppAssets.us,
    AppAssets.chinese,
    AppAssets.polish,
    AppAssets.euro,
    AppAssets.euro,
  ];

  List popPopName = [
    AppString.gluTine,
    AppString.noCi,
    AppString.lupini,
    AppString.soIa,
    AppString.latte,
    AppString.arAchIdi,
    AppString.seDaNo,
    AppString.peSce,
    AppString.peSce,
    AppString.peSce,
    AppString.peSce,
    AppString.peSce,
    AppString.peSce,
  ];

  void toggleSearch() {
    isTapped = !isTapped;
    update();
  }

  void updateSearchText(String text) {
    update();
  }

  void toggleSelection(String value) {
    if (selectedItems.contains(value)) {
      selectedItems.remove(value);
      Get.back();
    } else {
      selectedItems.add(value);
      Get.back();
    }
    update();
  }
}
