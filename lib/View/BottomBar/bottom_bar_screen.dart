import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/sql_helper.dart';
import 'package:urestaurants_user/View/BottomBar/controller/bottom_bar_controller.dart';
import 'package:urestaurants_user/View/BottomBar/no_internet_screen.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/HomeScreen/home_screen.dart';
import 'package:urestaurants_user/View/InfoScreen/info_screen.dart';
import 'package:urestaurants_user/View/MenuScreen/menu_screen.dart';
import 'package:urestaurants_user/View/Reservation/reservation_screen.dart';

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
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    try {
      data = await DatabaseHelper().getAllTableData(tableName: DatabaseHelper.restaurant);
      setState(() {});
    } catch (error) {
      log('error::::::::::::::::${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build screens array

    return GetBuilder<BottomBarController>(
      builder: (controller) {
        final List<Widget> screenName = [
          const HomeScreen(),
          const MenuScreen(),
          // const OrderScreen(),
          if (controller.isReservationAvailable) const ReservationScreen(),
          // const ParkingScreen(),
          const InfoScreen(),
        ];
        return Scaffold(
          backgroundColor: CupertinoColors.systemGrey6,

          appBar: AppBar(
            backgroundColor: CupertinoColors.systemGrey6,
            elevation: 0,
            toolbarHeight: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: CupertinoColors.systemGrey6,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),

          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CupertinoColors.systemGrey6,
              statusBarIconBrightness: Brightness.dark,
            ),
            child: (controller.isConnected == false && (data.isEmpty))
                ? NoInternetScreen()
                : (controller.isConnected == false && controller.selectScreen == 2 && controller.isReservationAvailable)
                    ? NoInternetScreen()
                    : screenName[controller.selectScreen],
          ),
          // BottomNavBar
          bottomNavigationBar: widget.pageFound
              ? Theme(
                  data: ThemeData(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                  ),
                  child: GetBuilder<HomeScreenController>(builder: (homeController) {
                    return BottomNavigationBar(
                      backgroundColor: CupertinoColors.systemGrey6.withOpacity(0.1),
                      selectedItemColor: AppColor.appColor,
                      unselectedItemColor: Colors.grey,
                      currentIndex: controller.selectScreen,
                      type: BottomNavigationBarType.fixed,
                      elevation: 0,
                      selectedFontSize: 10,
                      unselectedFontSize: 10,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.home),
                          label: homeController.selectedRestaurant?.info?.nome ?? AppString.home,
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(CupertinoIcons.book),
                          label: AppString.menu,
                        ),
                        if (controller.isReservationAvailable)
                          const BottomNavigationBarItem(
                            icon: Icon(
                              Icons.description_outlined,
                            ),
                            label: "Table",
                          ),
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
                    );
                  }),
                )
              : null,
        );
      },
    );
  }
}
