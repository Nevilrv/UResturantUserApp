import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/HomeScreen/widget/filter_button.dart';
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
      return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: FilterButton(
            onChanged: (p0) {
              controller.removeFilter(controller.selectedCity, "City");
              controller.addFilter(controller.cityFilter.elementAt(p0), "City");
              controller.updateSelectedCity(controller.cityFilter.elementAt(p0));
              controller.applyFilter();
            },
            data: controller.cityFilter,
            title: controller.selectedCity,
          ),
          leadingWidth: 100,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (controller.selectedRestaurant?.info?.nome ?? "Ai Trancentino")
                  .primaryMedium(fontColor: AppColor.appBlackColor, fontSize: 22),
              10.0.addHSpace(),
              Expanded(
                child: controller.isLoading
                    ? Center(
                        child: AppLoader().loader(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 35,
                              child: ListView.builder(
                                itemCount: controller.typeFilter.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (controller.selectedTypeFilters.contains(index)) {
                                        controller.removeFilter(controller.typeFilter.elementAt(index), "Type");
                                      } else {
                                        controller.addFilter(controller.typeFilter.elementAt(index), "Type");
                                      }
                                      controller.updateSelectedTypeFilters(index);
                                      controller.applyFilter();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: index == 0 ? 0 : 10, right: 10),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColor.appWhiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: controller.selectedTypeFilters.contains(index) ? AppColor.appColor : Colors.transparent,
                                        ),
                                      ),
                                      child: Center(
                                          child: controller.typeFilter
                                              .elementAt(index)
                                              .primaryMedium(fontColor: AppColor.appBlackColor, fontSize: 14)),
                                    ),
                                  );
                                },
                              ),
                            ),
                            20.0.addHSpace(),

                            /// Restaurants
                            if (controller.restaurantsData.isNotEmpty) ...[
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
                            ],

                            /// Pizzerias
                            if (controller.pizzeriasData.isNotEmpty) ...[
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
                            ],

                            /// Pizzerias
                            if (controller.trattoriasData.isNotEmpty) ...[
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
                              ),
                              20.0.addHSpace(),
                            ]
                          ],
                        ),
                      ),
              ),
            ],
          ).paddingSymmetric(horizontal: 10),
        ),
      );
    });
  }
}
