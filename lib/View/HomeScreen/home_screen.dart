import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/HomeScreen/widget/hotel_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(builder: (controller) {
      return controller.isLoading
          ? Center(
              child: AppLoader().loader(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (controller.selectedRestaurant?.info?.nome ?? "Ai Trancentino")
                      .primaryMedium(fontColor: AppColor.appBlackColor, fontSize: 22),
                  10.0.addHSpace(),
                  SizedBox(
                    height: 35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: index == 0 ? 0 : 10, right: 10),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(color: AppColor.appWhiteColor, borderRadius: BorderRadius.circular(10)),
                          child: Center(child: "Take away".primaryMedium(fontColor: AppColor.appBlackColor, fontSize: 14)),
                        );
                      },
                    ),
                  ),
                  20.0.addHSpace(),

                  /// Restaurants
                  "Restaurants".primarySemiBold(fontColor: AppColor.appBlackColor, fontSize: 22),
                  10.0.addHSpace(),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: controller.restaurantsData.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return HotelCard(
                          data: controller.restaurantsData[index],
                        ).paddingOnly(right: 10);
                      },
                    ),
                  ),
                  20.0.addHSpace(),

                  /// Pizzerias
                  "Pizzerias".primarySemiBold(fontColor: AppColor.appBlackColor, fontSize: 22),
                  10.0.addHSpace(),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: controller.pizzeriasData.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return HotelCard(
                          data: controller.pizzeriasData[index],
                        ).paddingOnly(right: 10);
                      },
                    ),
                  ),
                  20.0.addHSpace(),

                  /// Pizzerias
                  "Trattorias".primarySemiBold(fontColor: AppColor.appBlackColor, fontSize: 22),
                  10.0.addHSpace(),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: controller.trattoriasData.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return HotelCard(
                          data: controller.trattoriasData[index],
                        ).paddingOnly(right: 10);
                      },
                    ),
                  )
                ],
              ).paddingSymmetric(horizontal: 10),
            );
    });
  }
}
