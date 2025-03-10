import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/app_string.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/Utils/app_routes.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/BottomBar/controller/bottom_bar_controller.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/order_screen_controller.dart';
import 'package:urestaurants_user/Widgets/app_material_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderPageController orderPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: (AppString.orderTitle).primaryMedium(fontSize: 30, fontWeight: FontWeight.w600, fontColor: AppColor.appBlackColor)),
        ),
        body: GetBuilder<OrderPageController>(
          builder: (controller) {
            return controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.appColor,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "ULTIMI 7 ORDINI".primaryRegular(fontColor: AppColor.appGrey3Color, fontSize: 13).paddingOnly(
                              left: 10,
                              bottom: 2,
                            ),
                        Container(
                          height: 400,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  controller.order.length,
                                  (index) {
                                    return "${controller.order[index].data} | ${controller.order[index].ora}"
                                        .primaryMedium(fontSize: 20, fontColor: AppColor.appBlackColor)
                                        .paddingOnly(bottom: 2);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        50.0.addHSpace(),
                        AppMaterialButton(
                          text: "Nuovo Ordine",
                          onPressed: () {
                            if (Get.find<BottomBarController>().isConnected == true) {
                              if (preferences.getBool(SharedPreference.isLogin) == true) {
                                Get.toNamed(Routes.newOrderScreen);
                              } else {
                                Get.offAllNamed(Routes.loginScreen);
                              }
                            } else {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text("Errore"),
                                  content: const Text("Please connect with the internet"),
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
                          },
                        )
                      ],
                    ),
                  );
          },
        ));
  }
}
