import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/confirm_order_controller.dart';

import '../../constant/app_color.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key});

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  ConfirmOrderController confirmOrderController = Get.put(ConfirmOrderController());
  @override
  void initState() {
    confirmOrderController.generateSlot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmOrderController>(builder: (controller) {
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
              ("Confirm").primarySemiBold(fontSize: 15, fontColor: AppColor.appBlackColor, letterSpacing: 0.8),
              const Spacer(),
            ],
          ).paddingSymmetric(horizontal: 10),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              10.0.addHSpace(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "INFO"
                      .primaryRegular(fontWeight: FontWeight.w300, fontColor: AppColor.appGrey1Color, fontSize: 12)
                      .paddingOnly(left: 10, bottom: 5),
                  Container(
                    // height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Nome :   ${controller.userFirstName.capitalizeFirst}"
                            .primaryMedium(fontColor: AppColor.appBlack1Color, fontSize: 15, fontWeight: FontWeight.w200),
                        const Divider(
                          color: AppColor.appDividerColor,
                          height: 25,
                        ),
                        "Congnome :  ${controller.userLastName.capitalizeFirst}"
                            .primaryMedium(fontColor: AppColor.appBlack1Color, fontSize: 15, fontWeight: FontWeight.w200),
                        const Divider(
                          color: AppColor.appDividerColor,
                          height: 25,
                        ),
                        "Telefono :   +39 5855"
                            .primaryMedium(fontColor: AppColor.appBlack1Color, fontSize: 15, fontWeight: FontWeight.w200),
                      ],
                    ),
                  )
                ],
              ),
              4.h.addHSpace(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "ORARIO"
                      .primaryRegular(fontWeight: FontWeight.w300, fontColor: AppColor.appGrey1Color, fontSize: 12)
                      .paddingOnly(left: 10, bottom: 5),
                  Container(
                    // height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6), borderRadius: const BorderRadius.vertical(top: Radius.circular(10))),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            "Prima Possiblie".primaryMedium(fontColor: AppColor.appBlack1Color, fontSize: 15, fontWeight: FontWeight.w200),
                            const Spacer(),
                            SizedBox(
                              height: 30,
                              child: CupertinoSwitch(
                                value: controller.isSwitchOn,
                                onChanged: (value) {
                                  controller.toggleSwitch(value);
                                },
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: AppColor.appDividerColor,
                          height: 25,
                        ),
                        SizedBox(
                          height: 150,
                          child: CupertinoPicker(
                            key: controller.uniqueKey,
                            backgroundColor: Colors.white,
                            itemExtent: 40, // Height of each item
                            scrollController: FixedExtentScrollController(initialItem: controller.selectedTimeSlot ?? 0),
                            onSelectedItemChanged: (value) {
                              HapticFeedBack.buttonClick();
                              controller.updateTime(value);
                            },
                            diameterRatio: 1.5,
                            squeeze: 1,
                            children: controller.slots.map((slot) => Center(child: Text(slot, style: TextStyle(fontSize: 18)))).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.storeOrderData,
                    child: Container(
                      height: 45,
                      decoration:
                          const BoxDecoration(color: AppColor.appColor, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
                      child: Center(
                        child: "Conferma".primarySemiBold(
                          fontColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
