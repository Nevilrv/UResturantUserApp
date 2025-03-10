import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/BottomBar/controller/bottom_bar_controller.dart';
import 'package:urestaurants_user/View/HomeScreen/home_screen.dart';
import 'package:urestaurants_user/View/InfoScreen/info_screen.dart';
import 'package:urestaurants_user/View/MenuScreen/menu_screen.dart';
import 'package:urestaurants_user/View/OrderScreen/order_screen.dart';

import '../../Constant/app_color.dart';
import '../../Constant/app_string.dart';

class BottomBar extends StatefulWidget {
  final bool pageFound;
  final bool isReservation;

  const BottomBar({
    Key? key,
    required this.pageFound,
    required this.isReservation,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin {
  final BottomBarController bottomBarController = Get.put(BottomBarController());

  @override
  void initState() {
    super.initState();
    bottomBarController.onInitMethod(widget.isReservation);
  }

  @override
  Widget build(BuildContext context) {
    // Build screens array
    final List<Widget> screenName = [
      const HomeScreen(),
      const MenuScreen(),
      const OrderScreen(),
      // const ReservationScreen(),
      // const ParkingScreen(),
      const InfoScreen(),
    ];

    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: CupertinoColors.systemGrey6,

          appBar: controller.selectScreen != 0
              ? AppBar(
                  backgroundColor: CupertinoColors.systemGrey6,
                  elevation: 0,
                  toolbarHeight: 0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: CupertinoColors.systemGrey6,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                )
              : AppBar(
                  forceMaterialTransparency: true,
                  leading: Row(
                    children: [
                      10.0.addWSpace(),
                      Icon(
                        CupertinoIcons.location_fill,
                        color: AppColor.appColor,
                      ),
                      5.0.addWSpace(),
                      "All".primaryRegular(fontColor: AppColor.appColor)
                    ],
                  ),
                  leadingWidth: 100,
                  actions: [
                    Icon(
                      CupertinoIcons.map,
                      color: AppColor.appColor,
                      size: 25,
                    ),
                    10.0.addWSpace(),
                  ],
                ),

          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CupertinoColors.systemGrey6,
              statusBarIconBrightness: Brightness.dark,
            ),
            child: screenName[controller.selectScreen],
          ),
          // BottomNavBar
          bottomNavigationBar: widget.pageFound
              ? Theme(
                  data: ThemeData(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: CupertinoColors.systemGrey6.withOpacity(0.1),
                    selectedItemColor: AppColor.appColor,
                    unselectedItemColor: Colors.grey,
                    currentIndex: controller.selectScreen,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    selectedFontSize: 10,
                    unselectedFontSize: 10,
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.home),
                        label: AppString.home,
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.book),
                        label: AppString.menu,
                      ),
                      BottomNavigationBarItem(
                        icon: Image.asset(
                          AppAssets.foodDelivery,
                          color: controller.selectScreen == 1 ? AppColor.appColor : Colors.grey,
                          width: 25,
                          height: 25,
                        ),
                        label: AppString.order,
                      ),
                      // const BottomNavigationBarItem(
                      //   icon: Icon(
                      //     Icons.description_outlined,
                      //   ),
                      //   label: "Table",
                      // ),
                      // BottomNavigationBarItem(
                      //   icon: Image.asset(
                      //     AppAssets.car,
                      //     color: controller.selectScreen == 3 ? AppColor.appColor : Colors.grey,
                      //     width: 25,
                      //     height: 25,
                      //   ),
                      //   label: AppString.parking,
                      // ),
                      const BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.info),
                        label: AppString.info,
                      ),
                    ],
                    onTap: (value) {
                      HapticFeedBack.buttonClick();
                      controller.selectScreen = value;
                      setState(() {});
                    },
                  ),
                )
              : null,
        );
      },
    );
  }
}
