import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/app_string.dart';
import 'package:urestaurants_user/Constant/app_textstyle.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_responsive.dart';
import 'package:urestaurants_user/View/InfoPage/info_controller.dart';
import 'package:urestaurants_user/utils/app_sizebox.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  InfoController infoController = Get.put(InfoController());

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    await preferences.putString(SharedPreference.currentPage, "info");
    await infoController.initOrder();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InfoController>(
      builder: (controller) {
        return controller.fetchDataLoader || controller.addressValue || controller.days.isEmpty
            ? Container(
                color: appGreyColor,
                child: AppLoader().loader(),
              )
            : SingleChildScrollView(
                child: Container(
                  color: appGreyColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (Responsive.isTablet(context)
                                ? Responsive.width(context) / 10
                                : Responsive.isDesktop(context)
                                    ? Responsive.width(context) / 4
                                    : Responsive.is4k(context)
                                        ? Responsive.width(context) / 3.5
                                        : 0) +
                            10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text(
                                    controller.infoDataModel?.nome ?? "",
                                    style: black30w600,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      googleLoginSheet(context, controller);
                                    },
                                    child: const Icon(
                                      Icons.account_circle_outlined,
                                      size: 30,
                                      color: appColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                cachedNetworkImage(
                                  url: controller.infoDataModel?.logoUrl ?? "",
                                  height: Responsive.isTablet(context)
                                      ? 210
                                      : Responsive.isDesktop(context)
                                          ? 290
                                          : Responsive.is4k(context)
                                              ? 330
                                              : 170,
                                  width: double.infinity,
                                  name: "",
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(right: 7, bottom: 7),
                                      decoration: BoxDecoration(
                                        color: appWhiteColor.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(
                                        CupertinoIcons.share,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: appWhiteColor),
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
                                      Text(
                                        controller.isOpenOrNot() ? AppString.open : AppString.close,
                                        style: controller.isOpenOrNot() ? green16w400 : red16w400,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            infoController.days[0]["time"],
                                            style: black16w400,
                                          ),
                                          buildSizedBoxW(15),
                                          Icon(
                                            !controller.isContainerExpanded
                                                ? Icons.keyboard_arrow_down
                                                : Icons.keyboard_arrow_up_sharp,
                                            size: 17,
                                            color: appGreyArrowColor,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                color: appDividerColor,
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
                                                      dayName,
                                                      style: TextStyle(
                                                        color: infoController.days[index]["color1"],
                                                        fontSize: 15,
                                                        height: 1.8,
                                                      ),
                                                    ),
                                                    if (infoController.days[index]["color"] == Colors.red)
                                                      InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              contentPadding: EdgeInsets.zero,
                                                              backgroundColor: appGreyColor,
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
                                                                              borderRadius:
                                                                                  BorderRadius.all(Radius.circular(5))),
                                                                          child: const Icon(
                                                                            CupertinoIcons.check_mark,
                                                                            color: Colors.white,
                                                                            size: 18,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 8),
                                                                        const Text(
                                                                          'Orario Verificato',
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
                                                                      'L\'orario è attendibile in quanto il\nproprietario di questa attività lo ha\ninserito o aggiornato personalmente.',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(fontSize: 14),
                                                                    ),
                                                                  ),
                                                                  const Divider(height: 0),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: ClipRRect(
                                                                      borderRadius: const BorderRadius.vertical(
                                                                          bottom: Radius.circular(16)),
                                                                      child: Container(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 10),
                                                                        width: double.infinity,
                                                                        child: const Center(
                                                                          child: Text(
                                                                            'ok',
                                                                            style: TextStyle(
                                                                                fontSize: 16, color: appBlueColor),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
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
                                          color: appDividerColor,
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
                                      onTap: (position) async {
                                        controller.launchMap(controller.platform == 'IOS'
                                            ? controller.infoDataModel?.urlMaps ?? ""
                                            : controller.infoDataModel?.urlGMaps ?? "");
                                        FocusScope.of(context).unfocus();
                                      },
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
                                    color: appBlackColor,
                                  ),
                                ),
                              ),
                              const Divider(
                                color: appDividerColor,
                                indent: 15,
                                height: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.launchPhoneDialer(controller.infoDataModel?.telefono ?? "");
                                  },
                                  child: Text(
                                    "${AppString.tel} ${controller.infoDataModel?.telefono ?? ""}",
                                    style: black16w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(AppString.legalNotes),
                                  content: Text(
                                      'Lorem Ipsum e recently with desktop recently recently\nLorem Ipsum e recently with desktop'),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: appWhiteColor),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.book_circle_fill,
                                    color: appBlueColor,
                                  ),
                                  buildSizedBoxW(8),
                                  const Text(
                                    AppString.legalNotes,
                                    style: black16w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// TEMP HIDE

                        // reviewSection(controller),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10, bottom: 20),
                          child: const Text(
                            AppString.googleReview,
                            style: grey12w400appGreyColor5,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: appWhiteColor),
                          child: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.arrow_up_right_square,
                                color: appOrangeColor,
                                size: 20,
                              ),
                              SizedBox(
                                width: 13,
                              ),
                              Text(
                                AppString.addYourBussInEss,
                                style: black16w400,
                              ),
                            ],
                          ),
                        ),
                        buildSizedBoxH(10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            AppString.lastUpdate,
                            style: grey12w400appGreyColor5,
                          ),
                        ),
                        buildSizedBoxH(20),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  /// reviewSection

  // Column reviewSection(InfoController controller) {
  //   return Column(
  //     children: [
  //       buildSizedBoxH(3.h),
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           const Icon(
  //             CupertinoIcons.star_fill,
  //             color: Colors.amber,
  //             size: 19,
  //           ),
  //           buildSizedBoxW(1.w),
  //           Text(
  //             "${controller.infoDataModel?.star}",
  //             style: black18w600,
  //           ),
  //           const Spacer(),
  //           const Icon(
  //             CupertinoIcons.arrow_up_right_square,
  //             color: appBlackColor,
  //             size: 20,
  //           ),
  //           buildSizedBoxW(0.7.h),
  //           const Padding(
  //             padding: EdgeInsets.only(right: 15),
  //             child: Text(
  //               AppString.tutti,
  //               style: black14w400,
  //             ),
  //           ),
  //         ],
  //       ),
  //       buildSizedBoxH(0.8.h),
  //       SizedBox(
  //         height: 25.h,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           physics: const BouncingScrollPhysics(),
  //           itemCount: infoController.infoName.length,
  //           itemBuilder: (context, index) {
  //             return Container(
  //               width: Responsive.isTablet(context)
  //                   ? 40.w
  //                   : Responsive.isDesktop(context)
  //                       ? 30.w
  //                       : Responsive.is4k(context)
  //                           ? 20.w
  //                           : 70.w,
  //               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //               margin: const EdgeInsets.only(right: 10),
  //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: appWhiteColor),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       index == 3 || index == 6
  //                           ? Container(
  //                               decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(4), color: appGreenColor.withOpacity(0.2)),
  //                               child: const Center(
  //                                 child: Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //                                   child: Text(
  //                                     AppString.num55,
  //                                     style: green14w400,
  //                                   ),
  //                                 ),
  //                               ),
  //                             )
  //                           : Container(
  //                               decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(4), color: appOrangeColor.withOpacity(0.2)),
  //                               child: const Center(
  //                                 child: Padding(
  //                                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //                                   child: Text(
  //                                     AppString.num45,
  //                                     style: orange14w400,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                       buildSizedBoxW(2.w),
  //                       Text(
  //                         infoController.infoName[index],
  //                         style: black16w400,
  //                       ),
  //                     ],
  //                   ),
  //                   buildSizedBoxH(1.h),
  //                   const Text(
  //                     AppString.review,
  //                     style: black16w400,
  //                     maxLines: 5,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                   buildSizedBoxH(0.6.h),
  //                   const Text(
  //                     AppString.month,
  //                     style: grey12w400appGreyColor5,
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  /// legalNotes

  // PopupMenuButton<String> legalNotes(InfoController controller) {
  //   return PopupMenuButton<String>(
  //     padding: EdgeInsets.zero,
  //     color: appGreyColor2.withOpacity(0.90),
  //     onSelected: (String value) {},
  //     itemBuilder: (BuildContext context) {
  //       return [
  //         PopupMenuItem<String>(
  //           padding: EdgeInsets.zero,
  //           child: Container(
  //             width: 220,
  //             padding: EdgeInsets.zero,
  //             child: const Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 10),
  //                   child: Text(
  //                     AppString.toGliAllErgEne,
  //                     style: grey10w400,
  //                   ),
  //                 ),
  //                 Divider(color: appDividerColor),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ];
  //     },
  //   );
  // }

  /// appleLoginSheet

  Future<dynamic> appleLoginSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: appDarkGreyColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 35.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.login,
                      style: white30w600.copyWith(height: 2),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        infoController.iconColor = appBlueColor; // Reset icon color to blue
                      },
                      child: Container(
                        height: 3.5.h,
                        width: 3.5.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: appGreyColor2,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: appLightGreyColor,
                        ),
                      ),
                    ),
                  ],
                ),
                buildSizedBoxH(6.h),
                const Text(
                  AppString.youMustLogInToConFirmTheBooking,
                  style: lightGrey16w400,
                ),
                buildSizedBoxH(5.h),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: appBlackColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.apple,
                        color: appWhiteColor,
                      ),
                      buildSizedBoxW(2.w),
                      Text(
                        AppString.signInWithApple,
                        style: white18w600.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> googleLoginSheet(BuildContext context, InfoController controller) {
    bool isLogin = preferences.getBool(SharedPreference.isLogin) ?? false;

    return showModalBottomSheet(
      context: context,
      backgroundColor: appDarkGreyColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.login,
                          style: white30w600.copyWith(height: 2, color: Colors.black),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            infoController.iconColor = appBlueColor; // Reset icon color to blue
                          },
                          child: Container(
                            height: 3.5.h,
                            width: 3.5.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      AppString.youMustLogInToConFirmTheBooking,
                      style: lightGrey16w400,
                    ),
                    const Spacer(),
                    controller.googleSignLoader == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: appColor,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: GestureDetector(
                              onTap: () async {
                                await controller.googleSignIn(context: context, setState: setState);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: appGreyColor4.withOpacity(0.5),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    assetImage(AppAssets.google, height: 25, width: 25),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      AppString.signInWithGoogle,
                                      style: white18w600.copyWith(fontSize: 15, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    buildSizedBoxH(10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
