import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/app_responsive.dart';
import 'package:urestaurants_user/View/Bottombar/bottombar_controller.dart';

import '../InfoPage/info_screen.dart';
import '../MenuPage/menu_screen.dart';
import '../Reservation/reservation_screen.dart';

class BottomBar extends StatefulWidget {
  final bool pageFound;
  final bool isReservation;
  const BottomBar({
    super.key,
    required this.pageFound,
    required this.isReservation,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin {
  BottomBarController bottomBarController = Get.put(BottomBarController());

  @override
  void initState() {
    bottomBarController.onInitMethod(widget.isReservation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List screenName = [
      const MenuScreen(),
      if (widget.isReservation) const ReservationScreen(),
      const InfoScreen(),
    ];
    return GetBuilder<BottomBarController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: appGreyColor,
          bottomNavigationBar: widget.pageFound
              ? Responsive.isMobile(context)
                  ? Theme(
                      data: ThemeData(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                      ),
                      child: BottomNavigationBar(
                        backgroundColor: Colors.white,
                        selectedItemColor: appColor,
                        selectedIconTheme: const IconThemeData(color: appColor),
                        elevation: 0,
                        type: BottomNavigationBarType.fixed,
                        selectedFontSize: 10,
                        unselectedFontSize: 10,
                        unselectedItemColor: Colors.grey,
                        currentIndex: controller.selectScreen,
                        items: [
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.menu_book),
                            label: "Menu",
                          ),
                          if (widget.isReservation)
                            const BottomNavigationBarItem(
                              icon: Icon(
                                Icons.description_outlined,
                              ),
                              label: "Table",
                            ),
                          const BottomNavigationBarItem(
                            icon: Icon(Icons.info_outline),
                            label: "info",
                          ),
                        ],
                        onTap: (value) {
                          controller.selectScreen = value;
                          setState(() {});
                        },
                      ),
                    )
                  : const SizedBox()
              : const SizedBox(),
          body: widget.pageFound
              ? Responsive.isMobile(context)
                  ? screenName[controller.selectScreen]
                  : Column(
                      children: [
                        Align(
                          alignment: Responsive.isMobile(context) ? Alignment.bottomCenter : Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Responsive.isTablet(context)
                                    ? Responsive.width(context) / 10
                                    : Responsive.isDesktop(context)
                                        ? Responsive.width(context) / 4
                                        : Responsive.is4k(context)
                                            ? Responsive.width(context) / 3.5
                                            : 0),
                            child: Container(
                              // width: Responsive.width(context) * 0.75,
                              margin: const EdgeInsets.only(top: 20, bottom: 10),
                              decoration: BoxDecoration(
                                color: appDarkGreyColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: List.generate(
                                  widget.isReservation ? 3 : 2,
                                  (index) => widget.isReservation
                                      ? index == 0
                                          ? menu(controller, index)
                                          : index == 1
                                              ? reservation(controller, index)
                                              : info(controller, index)
                                      : index == 0
                                          ? menu(controller, index)
                                          : info(controller, index),
                                ),
                              ),
                            ),
                          ),
                        ),
                        widget.isReservation
                            ? Expanded(
                                child: controller.selectScreen == 0
                                    ? const MenuScreen()
                                    : controller.selectScreen == 1
                                        ? const ReservationScreen()
                                        : const InfoScreen(),
                              )
                            : Expanded(
                                child: controller.selectScreen == 0 ? const MenuScreen() : const InfoScreen(),
                              ),
                      ],
                    )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "There was unknown error while\nprocessing the request!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(child: Image.asset("assets/images/page_not.png", height: 200, width: 200)),
                  ],
                ),
        );
      },
    );
  }

  Widget menu(BottomBarController controller, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeTab(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          margin: const EdgeInsets.all(6).copyWith(right: 0),
          decoration: controller.selectScreen == index
              ? BoxDecoration(color: appGreyColor, borderRadius: BorderRadius.circular(26))
              : const BoxDecoration(),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  color: Colors.black,
                ),
                SizedBox(width: 6),
                Text(
                  "Menu",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reservation(BottomBarController controller, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeTab(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          margin: const EdgeInsets.all(6).copyWith(left: 0),
          decoration: controller.selectScreen == index
              ? BoxDecoration(color: appGreyColor, borderRadius: BorderRadius.circular(26))
              : const BoxDecoration(),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 6),
                Text(
                  "Table",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget info(BottomBarController controller, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeTab(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          margin: const EdgeInsets.all(6).copyWith(left: 0),
          decoration: controller.selectScreen == index
              ? BoxDecoration(color: appGreyColor, borderRadius: BorderRadius.circular(26))
              : const BoxDecoration(),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.black,
                ),
                SizedBox(width: 6),
                Text(
                  "Info",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
