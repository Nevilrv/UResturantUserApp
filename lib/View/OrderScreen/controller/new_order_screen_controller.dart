import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/View/OrderScreen/models/ingredient_model.dart';
import 'package:urestaurants_user/View/OrderScreen/models/iteam_model.dart';

import '../../../Constant/app_color.dart';

class NewOrderScreenController extends GetxController {
  List<String> type = ["Normali", "Maxi", "Scrocchiarelle", "Contorni"];
  List<ItemModel> items = [];
  List<Ingredient> ingredient = [];
  ItemType selectedItemType = ItemType.normal;
  int selectedIndex = 0;
  List<BuyItem> buyItem = [];
  int totalItem = 0;
  ScrollController _scrollController = ScrollController();
  get scrollController => _scrollController;
  int? selectedItemIndex;

  updateSelectedItemIndex(int index) {
    selectedItemIndex = index;
    update();
  }

  addItem(BuyItem item) {
    int maxItems = 14;

    if (item.itemType == ItemType.maxi3) {
      maxItems = 11;
    } else if (item.itemType == ItemType.maxi4) {
      maxItems = 12;
    }

    if (totalItem >= maxItems) {
      showDialog(title: "Errore", discription: "E' possibile ordinare al massimo 14 prodotti alla volta");
      return;
    }
    buyItem.add(item);
    totalItem++;
    log('totalItem::::::::::::::::${totalItem}');
    update();

    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  removeItem(int index) {
    if (buyItem[index].itemType == ItemType.normal || buyItem[index].itemType == ItemType.maxi1) {
      totalItem--;
    }

    totalItem = totalItem - buyItem[index].subItem.length;
    buyItem.removeAt(index);
    update();
  }

  removeSubItem(int index, int subItemIndex) {
    buyItem[index].subItem.removeAt(subItemIndex);
    totalItem--;
    update();
  }

  addIngredient(BuyItem subItem, [String? itemName]) {
    log('totalItem::::::::::::::::${totalItem}');
    if (totalItem >= 14) {
      showDialog(title: "Errore", discription: "E' possibile ordinare al massimo 14 prodotti alla volta");
      return;
    }
    if (itemName != null) {
      updateLastOccurrence(buyItem, itemName, subItem);
    } else {
      buyItem.last.subItem.add(subItem);
    }
    if (subItem.isMainItem) {
      scrollToBottom();
    }
    totalItem++;
    update();
  }

  updateSelectedType({required ItemType type, required int index}) {
    HapticFeedBack.buttonClick();
    selectedIndex = index;
    selectedItemType = type;
    update();
  }

  clearData() {
    buyItem = [];
    selectedItemType = ItemType.normal;
    selectedIndex = 0;
    totalItem = 0;
    update();
  }

  getData({bool? isSame = false}) async {
    // String pizzaItem = preferences.getString(SharedPreference.pizzaItemData) ?? "";
    // String ingredientData = preferences.getString(SharedPreference.ingredientData) ?? "";
    // if (isSame == true && pizzaItem.isNotEmpty && ingredientData.isNotEmpty) {
    //   getDataFromLocal(pizzaItem, ingredientData);
    // } else {
    //   final snapshot = await MenuConfig().itemFromAnother();
    //
    //   if (snapshot != null) {
    //     List decodedData = jsonDecode(jsonEncode(snapshot.value));
    //     preferences.putString(SharedPreference.pizzaItemData, jsonEncode(snapshot.value));
    //     items = List<ItemModel>.from(decodedData.map(
    //       (e) => ItemModel.fromJson(e),
    //     ));
    //   }
    //   final snapshot2 = await MenuConfig().itemIngredient();
    //
    //   if (snapshot2 != null) {
    //     List decodedData = jsonDecode(jsonEncode(snapshot2.value));
    //     preferences.putString(SharedPreference.ingredientData, jsonEncode(snapshot2.value));
    //     ingredient = List<Ingredient>.from(decodedData
    //         .where(
    //           (element) => element != null,
    //         )
    //         .map(
    //           (e) => Ingredient.fromJson(e),
    //         ));
    //   }
    // }

    update();
  }

  getDataFromLocal(String pizzaItem, String ingredientData) {
    List pizzaData = jsonDecode(pizzaItem);
    items = List<ItemModel>.from(pizzaData.map(
      (e) => ItemModel.fromJson(e),
    ));
    List ingredientItemData = jsonDecode(ingredientData);
    ingredient = List<Ingredient>.from(ingredientItemData
        .where(
          (element) => element != null,
        )
        .map(
          (e) => Ingredient.fromJson(e),
        ));
  }

  bool checkValidationForChangeItemType() {
    if (buyItem.isEmpty) {
      return true;
    } else {
      if (buyItem.last.itemType == ItemType.normal || buyItem.last.itemType == ItemType.maxi1) {
        return true;
      } else {
        if (buyItem.last.itemType == ItemType.maxi2 && buyItem.last.subItem.length >= 2) {
          return true;
        }
        if (buyItem.last.itemType == ItemType.maxi3 && buyItem.last.subItem.length >= 3) {
          return true;
        }
        if (buyItem.last.itemType == ItemType.maxi4 && buyItem.last.subItem.length >= 4) {
          return true;
        }
        if (buyItem.last.itemType == ItemType.scrocchiarelle && buyItem.last.subItem.length >= 2) {
          return true;
        }
      }
    }

    return false;
  }

  void updateLastOccurrence(List<BuyItem> items, String itemName, BuyItem nawItem) {
    int? lastItemIndex;
    int? lastSubItemIndex;

    bool isMainItemLast = false;

    bool searchInSubItems(List<BuyItem> itemList, int itemIndex) {
      for (var i = itemList.length - 1; i >= 0; i--) {
        var item = itemList[i];

        if (item.name.contains(itemName)) {
          lastItemIndex = itemIndex;
          lastSubItemIndex = i;
          isMainItemLast = false;
          return true;
        }
      }
      return false;
    }

    for (var i = items.length - 1; i >= 0; i--) {
      var item = items[i];

      if (item.name.contains(itemName)) {
        lastItemIndex = i;
        isMainItemLast = true;
        break;
      }

      if (item.subItem.isNotEmpty) {
        bool result = searchInSubItems(item.subItem, i);
        if (result) {
          break;
        }
      }
    }
    log('lastItemIndex::::::::::::::::${lastItemIndex}');
    log('lastSubItemIndex::::::::::::::::${lastSubItemIndex}');

    try {
      if (lastItemIndex == null && lastSubItemIndex == null) {
        log('Please Select that item first::::::::::::::::');
        showDialog(title: "Avvertimento", discription: "Seleziona prima l'elemento per aggiungere un nuovo ingrediente");
      } else {
        buyItem[lastItemIndex ?? 0].subItem.add(nawItem);
      }
    } catch (error) {
      log('error:While Getting last item:::::::::::::::${error}');
    }
  }

  showDialog({String? title, String? discription}) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(discription ?? ""),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              "OK",
              style: TextStyle(fontSize: 16, color: AppColor.appColor),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

enum ItemType {
  normal,
  maxi1,
  maxi2,
  maxi3,
  maxi4,
  scrocchiarelle,
  contorni,
  pizza,
  addVariants,
  subtractedVariants,
}

class BuyItem {
  final String name;
  final String qty;
  final String amount;
  final List<BuyItem> subItem;
  final ItemType itemType;
  final bool isMainItem;
  final String cod;

  BuyItem({
    required this.name,
    required this.qty,
    required this.amount,
    required this.subItem,
    required this.itemType,
    required this.isMainItem,
    required this.cod,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'amount': amount,
      'subItem': subItem.map((item) => item.toJson()).toList(),
      'itemType': itemType.toString().split('.').last, // Convert enum to string
      'isMainItem': isMainItem,
      'cod': cod,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
