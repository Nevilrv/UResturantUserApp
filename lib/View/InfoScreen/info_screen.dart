import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/app_string.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_routes.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/InfoScreen/controller/info_controller.dart';
import 'package:urestaurants_user/View/LoginScreen/login_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  InfoController infoController = Get.find();

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    infoController.initScrollListener();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InfoController>(
      builder: (controller) {
        return controller.fetchDataLoader || controller.addressValue || controller.days.isEmpty
            ? Container(
                color: AppColor.appGreyColor,
                child: AppLoader().loader(),
              )
            : Scaffold(
                backgroundColor: CupertinoColors.systemGrey6,
                appBar: AppBar(
                  toolbarHeight: 45,
                  backgroundColor: Colors.transparent,
                  forceMaterialTransparency: true,
                  foregroundColor: Colors.transparent,
                  title: AnimatedOpacity(
                      opacity: controller.isShowAppBarText ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: (controller.infoDataModel?.nome ?? "").primaryRegular(fontColor: Colors.black)),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Container(
                    color: AppColor.appGreyColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: (controller.infoDataModel?.nome ?? "")
                                          .primaryMedium(fontSize: 30, fontWeight: FontWeight.w600, fontColor: AppColor.appBlackColor)),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      if (preferences.getBool(SharedPreference.isLogin) == true) {
                                        Get.toNamed(Routes.profileScreen);
                                      } else {
                                        Get.bottomSheet(LoginScreen());
                                      }
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.profile_circled,
                                      color: AppColor.appColor,
                                      size: 32,
                                    ),
                                  )
                                ],
                              ),
                              cachedNetworkImage(
                                url: controller.infoDataModel?.logoUrl ?? "",
                                name: "name",
                                height: 170,
                                width: double.infinity,
                                radius: 10,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColor.appWhiteColor),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      infoController.toggleContainerState();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(controller.isOpenOrNot() ? AppString.open : AppString.close,
                                            style: TextStyle(
                                                fontFamily: 'SfProDisplay',
                                                color: controller.isOpenOrNot() ? AppColor.appGreenColor : AppColor.appRedColor,
                                                fontSize: 16)),
                                        Row(
                                          children: [
                                            (infoController.days[0]["time"].toString() ?? "")
                                                .primaryMedium(fontSize: 16, fontColor: AppColor.appBlackColor),
                                            15.0.addWSpace(),
                                            Icon(
                                              !controller.isContainerExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up_sharp,
                                              size: 17,
                                              color: AppColor.appGreyArrowColor,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: AppColor.appDividerColor,
                                  indent: 15,
                                  height: 25,
                                ),
                                infoController.isContainerExpanded
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Column(
                                              children: List.generate(
                                                7,
                                                (index) {
                                                  final dayName = infoController.days[index]["day"];
                                                  String dayTime = infoController.days[index]["time"];
                                                  if (index == 0) {
                                                    return const SizedBox();
                                                  }
                                                  return Row(
                                                    children: [
                                                      Text(
                                                        dayName ?? "",
                                                        style: TextStyle(
                                                          fontFamily: 'SfProDisplay',
                                                          color: infoController.days[index]["color1"],
                                                          fontSize: 15,
                                                          height: 1.8,
                                                        ),
                                                      ),
                                                      if (infoController.days[index]["color"] == Colors.red)
                                                        InkWell(
                                                          onTap: () {
                                                            controller.updateMapOnTap(false);
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible: false,
                                                              builder: (context) => AlertDialog(
                                                                contentPadding: EdgeInsets.zero,
                                                                backgroundColor: AppColor.appGreyColor,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(16),
                                                                ),
                                                                content: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    const SizedBox(height: 15),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 14),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            padding: const EdgeInsets.all(2),
                                                                            decoration: const BoxDecoration(
                                                                                color: Colors.green,
                                                                                borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                            child: const Icon(
                                                                              CupertinoIcons.check_mark,
                                                                              color: Colors.white,
                                                                              size: 18,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 8),
                                                                          const Text(
                                                                            AppString.verification,
                                                                            style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 18)
                                                                          .copyWith(top: 10, bottom: 16),
                                                                      child: const Text(
                                                                        AppString.verificationText,
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(fontSize: 14),
                                                                      ),
                                                                    ),
                                                                    const Divider(height: 0),
                                                                    Stack(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            controller.updateMapOnTap(true);
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child: ClipRRect(
                                                                            borderRadius:
                                                                                const BorderRadius.vertical(bottom: Radius.circular(16)),
                                                                            child: Container(
                                                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                                                              width: double.infinity,
                                                                              child: const Center(
                                                                                child: Text(
                                                                                  AppString.okay,
                                                                                  style:
                                                                                      TextStyle(fontSize: 16, color: AppColor.appBlueColor),
                                                                                ),
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
                                                          },
                                                          child: const Icon(
                                                            Icons.verified_outlined,
                                                            color: Colors.green,
                                                            size: 17,
                                                          ).paddingOnly(left: 5),
                                                        ),
                                                      const Spacer(),
                                                      Text(
                                                        dayTime,
                                                        style: TextStyle(
                                                          fontFamily: 'SfProDisplay',
                                                          color: infoController.days[index]["color"],
                                                          fontSize: 15,
                                                          height: 1.8,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const Divider(
                                            color: AppColor.appDividerColor,
                                            indent: 15,
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 160,
                                      child: GoogleMap(
                                        compassEnabled: false,
                                        zoomControlsEnabled: false,
                                        zoomGesturesEnabled: false,
                                        onTap: controller.mapOnTap
                                            ? (position) async {
                                                controller.launchMap(controller.platform == 'IOS'
                                                    ? controller.infoDataModel?.urlMaps ?? ""
                                                    : controller.infoDataModel?.urlGMaps ?? "");
                                                FocusScope.of(context).unfocus();
                                              }
                                            : null,
                                        onCameraMove: (position) {
                                          if (controller.customInfoWindowController.onCameraMove != null) {
                                            controller.customInfoWindowController.onCameraMove!();
                                          }
                                        },
                                        onMapCreated: (GoogleMapController googleMapController) {
                                          controller.getGoogleMapController(googleMapController);
                                          controller.customInfoWindowController.googleMapController = googleMapController;
                                        },
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(controller.coordinates![0], controller.coordinates![1]),
                                          zoom: 15,
                                        ),
                                        markers: controller.markers,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 5),
                                  child: Text(
                                    controller.fullAddress ??
                                        "${controller.infoDataModel?.atr1 ?? ""}${(controller.infoDataModel?.atr1?.isNotEmpty) ?? false ? "," : ""} ${controller.infoDataModel?.atr2 ?? ""}${(controller.infoDataModel?.atr2?.isNotEmpty) ?? false ? "," : ""} ${controller.infoDataModel?.city ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColor.appBlackColor,
                                    ),
                                  ),
                                ),
                                const Divider(
                                  color: AppColor.appDividerColor,
                                  indent: 15,
                                  height: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.launchPhoneDialer(controller.infoDataModel?.telefono ?? "");
                                    },
                                    child: "${AppString.tel} ${controller.infoDataModel?.telefono ?? ""}".primaryRegular(
                                      fontSize: 16,
                                      fontColor: AppColor.appBlackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (controller.isShowWifi)
                            GestureDetector(
                              onTap: () {
                                controller.checkWifi();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.appWhiteColor),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.wifi,
                                        color: AppColor.appBlueColor.withOpacity(0.8),
                                      ),
                                      8.0.addWSpace(),
                                      AppString.configureWifi.primaryRegular(fontSize: 16, fontColor: AppColor.appBlackColor),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 20, bottom: 10),
                            child: AppString.googleReview.primaryRegular(fontSize: 12, fontColor: AppColor.appGreyColor5),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: AppColor.appWhiteColor),
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.arrow_up_right_square,
                                  color: AppColor.appOrangeColor,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 13,
                                ),
                                AppString.addYourBussInEss.primaryRegular(fontColor: AppColor.appBlackColor, fontSize: 16),
                              ],
                            ),
                          ),
                          20.0.addHSpace(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
