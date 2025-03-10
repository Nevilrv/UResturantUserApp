import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/new_order_screen_controller.dart';
import 'package:urestaurants_user/View/OrderScreen/models/ingredient_model.dart';

class IngredientBottomSheet extends StatelessWidget {
  const IngredientBottomSheet({super.key, required this.itemName});
  final String itemName;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      // expand: true,
      initialChildSize: 1,
      minChildSize: 1,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            color: CupertinoColors.white,
          ),
          child: GetBuilder<NewOrderScreenController>(builder: (controller) {
            log('controller.ingredient.length::::::::::::::::${controller.ingredient.length}');
            return ListView.builder(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.ingredient.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        "${controller.ingredient[index].name}".primaryMedium(
                          fontColor: AppColor.appBlackColor,
                          fontSize: 16,
                        ),
                        const Spacer(),
                        Container(
                          width: 75,
                          height: 30,
                          decoration:
                              BoxDecoration(color: AppColor.appGreyColor5.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.buyItem.isEmpty) {
                                      showDialog(
                                        context,
                                        discription: "Per poter modicare una pizza e necessario prima selezionarla",
                                        title: "Attenzione",
                                      );
                                      return;
                                    }
                                    Ingredient ingredient = controller.ingredient[index];
                                    controller.addIngredient(
                                        BuyItem(
                                          name: ingredient.name ?? "",
                                          amount: '',
                                          isMainItem: false,
                                          cod: (controller.selectedIndex == 0 ? ingredient.cod : ingredient.codMaxi).toString(),
                                          qty: "",
                                          subItem: [],
                                          itemType: ItemType.subtractedVariants,
                                        ),
                                        itemName);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: AppColor.appDividerColor,
                                height: 15,
                                width: 0.6,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (controller.buyItem.isEmpty) {
                                      showDialog(
                                        context,
                                        discription: "Per poter modicare una pizza e necessario prima selezionarla",
                                        title: "Attenzione",
                                      );
                                      return;
                                    }
                                    double price = 0.0;
                                    Ingredient ingredient = controller.ingredient[index];
                                    String cod = ingredient.codMaxi.toString();
                                    if (controller.selectedIndex == 0) {
                                      cod = ingredient.cod.toString();
                                      price = ingredient.pricePlusD ?? 0;
                                    } else if (controller.selectedIndex == 1) {
                                      if (controller.selectedItemType == ItemType.maxi1) {
                                        double priceM = ingredient.pricePlusM ?? 0.0;
                                        price = double.tryParse((priceM).toStringAsFixed(2)) ?? 0.0;
                                      } else if (controller.selectedItemType == ItemType.maxi2) {
                                        double priceM = ingredient.pricePlusM ?? 0.0;
                                        price = double.tryParse(((priceM / 2) * 1.1).toStringAsFixed(2)) ?? 0.0;
                                      } else if (controller.selectedItemType == ItemType.maxi3) {
                                        double priceM = ingredient.pricePlusM ?? 0.0;
                                        price = double.tryParse(((priceM / 3 * 1.1)).toStringAsFixed(2)) ?? 0.0;
                                      } else if (controller.selectedItemType == ItemType.maxi4) {
                                        double priceM = ingredient.pricePlusM ?? 0.0;
                                        price = double.tryParse(((priceM / 3 * 1.1)).toStringAsFixed(2)) ?? 0.0;
                                      }
                                    } else if (controller.selectedIndex == 2) {
                                      double priceM = ingredient.pricePlusM ?? 0.0;
                                      price = double.tryParse(((priceM / 2) * 1.2).toStringAsFixed(2)) ?? 0.0;
                                    }
                                    log('price::::::::::::::::${ingredient.toJson()}');
                                    controller.addIngredient(
                                        BuyItem(
                                          name: ingredient.name ?? "",
                                          amount: price.toStringAsFixed(2),
                                          isMainItem: false,
                                          cod: cod,
                                          qty: "",
                                          subItem: [],
                                          itemType: ItemType.addVariants,
                                        ),
                                        itemName);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 0.8,
                      color: AppColor.appDividerColor,
                    )
                  ],
                );
              },
            );
          }),
        );
      },
    );
  }

  showDialog(BuildContext context, {String? title, String? discription}) {
    showCupertinoDialog(
      context: context,
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
