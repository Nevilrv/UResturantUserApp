import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_routes.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/final_order_controller.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/new_order_screen_controller.dart';

import '../../Constant/app_color.dart';

class FinalOrderScreen extends StatefulWidget {
  const FinalOrderScreen({super.key});

  @override
  State<FinalOrderScreen> createState() => _FinalOrderScreenState();
}

class _FinalOrderScreenState extends State<FinalOrderScreen> {
  FinalOrderController finalOrderController = Get.put(FinalOrderController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinalOrderController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          leadingWidth: 0,
          forceMaterialTransparency: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                  onTap: () {
                    HapticFeedBack.buttonClick();
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColor.appBlueColor,
                  )),
              const Spacer(),
              ("Riepilogo").primarySemiBold(fontSize: 15, fontColor: AppColor.appBlackColor, letterSpacing: 0.8),
              const Spacer(),
            ],
          ).paddingSymmetric(horizontal: 10),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: List.generate(
                      controller.buyItem.length,
                      (index) {
                        BuyItem item = controller.buyItem[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  "${item.qty} x ${item.name}".primaryRegular(fontColor: AppColor.appBlackColor),
                                  const Spacer(),
                                  "${item.subItem.any(
                                    (element) => element.isMainItem == true,
                                  ) ? "" : "€"} ${item.amount}"
                                      .primaryRegular(fontColor: AppColor.appBlackColor),
                                ],
                              ),
                              if (item.subItem.isNotEmpty)
                                Column(
                                  children: List.generate(
                                    item.subItem.length,
                                    (subItemIndex) {
                                      BuyItem subItem = item.subItem[subItemIndex];
                                      return Row(
                                        children: [
                                          "${subItem.isMainItem ? "${subItem.qty} x" : subItem.itemType == ItemType.subtractedVariants ? "-" : "+"} ${subItem.name}"
                                              .primaryRegular(
                                            fontColor: AppColor.appBlackColor,
                                          ),
                                          const Spacer(),
                                          (subItem.itemType == ItemType.subtractedVariants ? "" : "€ ${subItem.amount}").primaryRegular(
                                            fontColor: AppColor.appBlackColor,
                                          ),
                                        ],
                                      ).paddingOnly(left: 15, top: 5);
                                    },
                                  ),
                                )
                            ],
                          ),
                        );
                      },
                    ),
                  ).paddingSymmetric(vertical: 10),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          "Applica Sconto".primaryMedium(fontColor: AppColor.appColor),
                          Spacer(),
                          "Totale:  € ${controller.totalPrice.toStringAsFixed(2)}".primaryMedium(fontColor: AppColor.appBlackColor),
                        ],
                      ).paddingSymmetric(horizontal: 15),
                      10.0.addHSpace(),
                      GestureDetector(
                        onTap: () {
                          HapticFeedBack.buttonClick();
                          Get.toNamed(Routes.confirmOrderScreen, arguments: controller.buyItem);
                        },
                        child: Container(
                          height: 45,
                          decoration:
                              BoxDecoration(color: AppColor.appColor, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
                          child: Center(
                            child: "Proceed".primaryMedium(
                              fontColor: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
