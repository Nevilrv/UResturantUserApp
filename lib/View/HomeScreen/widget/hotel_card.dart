import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/cache_manager.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/BottomBar/controller/bottom_bar_controller.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/HomeScreen/model/all_data_model.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({super.key, required this.data});

  final AllDataModel data;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(builder: (controller) {
      bool isBothAttributeAvailable = ((data.info?.atr1 != null && data.info?.atr2 != null) &&
          ((data.info?.atr1 ?? "").isNotEmpty && (data.info?.atr2 ?? "").isNotEmpty));
      return GestureDetector(
        onTap: () {
          controller.updateSelectedRestaurant(data);
          HapticFeedBack.buttonClick();
          Get.find<BottomBarController>().changeTab(1);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 180,
          width: 250,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 130,
                width: 250,
                child: Stack(
                  children: [
                    Builder(builder: (context) {
                      return Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Builder(builder: (context) {
                            return CachedNetworkImage(
                              imageUrl: data.info?.logoUrl ?? "",
                              fit: BoxFit.cover,
                              cacheManager: CustomCacheManager(),
                              placeholder: (context, url) {
                                return Shimmer.fromColors(
                                  baseColor: AppColor.appDarkGreyColor,
                                  highlightColor: AppColor.appLightGreyColor,
                                  child: Container(
                                    color: AppColor.appDarkGreyColor,
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      );
                    }),
                    if (controller.selectedRestaurant?.id == data.id)
                      Container(
                        height: 35,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Color(0xffFF9501),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: "Selected".primaryMedium(fontColor: AppColor.appWhiteColor),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppAssets.star,
                              height: 10,
                              width: 10,
                            ),
                            3.0.addWSpace(),
                            "${data.info?.star}".primaryMedium(fontColor: AppColor.appBlackColor, fontSize: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    "${data.info?.nome}"
                        .primaryMedium(fontColor: AppColor.appBlackColor, fontSize: 16, maxLine: 1, textOverflow: TextOverflow.ellipsis),

                    Row(
                      children: [
                        "${data.info?.atr1}".primaryMedium(fontColor: AppColor.appGreyColor5, fontSize: 12, maxLine: 1),
                        if (isBothAttributeAvailable) ...[
                          3.0.addWSpace(),
                          "•".primaryMedium(fontColor: AppColor.appGreyColor5, fontSize: 12, maxLine: 1),
                          3.0.addWSpace(),
                        ],
                        "${data.info?.atr2}".primaryMedium(fontColor: AppColor.appGreyColor5, fontSize: 12, maxLine: 1),
                      ],
                    )
                    // "${data.info?.atr1} • ${data.info?.atr2}"
                  ],
                ).paddingSymmetric(
                  horizontal: 10,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
