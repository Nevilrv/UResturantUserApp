import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/BottomBar/controller/bottom_bar_controller.dart';
import 'package:urestaurants_user/View/LoginScreen/login_screen.dart';
import 'package:urestaurants_user/View/Reservation/reservation_controller.dart';

import '../../Constant/app_string.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  ReservationController controller = Get.find();

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    bool isLogin = preferences.getBool(SharedPreference.isLogin) ?? false;
    if (!isLogin) {
      Future.delayed(Duration(milliseconds: 500)).then(
        (value) async {
          bool? result = await Get.bottomSheet(LoginScreen());
          log('result::::::::::::::::${result}');
          if (result == null) {
            Get.find<BottomBarController>().changeTab(0);
          }
        },
      );
    }
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReservationController>(
      builder: (controller) {
        return controller.fetchDataLoader
            ? Container(
                color: AppColor.appGreyColor,
                child: AppLoader().loader(),
              )
            : SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  color: AppColor.appGreyColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: AppString.reservation.primaryBold(fontSize: 30, fontColor: AppColor.appBlackColor)),
                        5.0.addHSpace(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10).copyWith(left: 15),
                                child: AppString.numberOfPeople
                                    .toUpperCase()
                                    .primaryRegular(fontColor: AppColor.appLightGreyColor, fontSize: 15)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  controller.numbers.length,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.setSelectedNumber(controller.numbers[index]);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: controller.numbers[index] == controller.selectedTableNumber
                                                ? Border.all(color: AppColor.appColor, width: 3)
                                                : null,
                                          ),
                                          child: Center(
                                            child: controller.numbers[index].toString().primaryRegular(
                                                  fontSize: 17,
                                                  fontColor: AppColor.appBlack1Color,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        calenderView(controller).paddingSymmetric(vertical: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10).copyWith(left: 15),
                                child: AppString.hours.toUpperCase().primaryRegular(fontColor: AppColor.appLightGreyColor, fontSize: 15)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                children: List.generate(
                                  controller.timeList.length,
                                  (index) {
                                    String time = controller.timeList[index];
                                    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 1));
                                    int hour = int.parse(time.split(":")[0]);
                                    int minute = int.parse(time.split(":")[1]);
                                    final formattedTime = DateTime(controller.selectedDate.year, controller.selectedDate.month,
                                        controller.selectedDate.day, hour, minute);
                                    return formattedTime.isBefore(now)
                                        ? const SizedBox()
                                        : Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (controller.selectedTableNumber == null) {
                                                  selectTableWarning(context);
                                                  return;
                                                }
                                                controller.setSelectedTime(controller.timeList[index]);
                                                controller.selectedTableNumber != 0 ? openConfirmationMenu(context) : null;
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      controller.selectedTableNumber == null ? AppColor.appGrey3Color : AppColor.appColor,
                                                  borderRadius: BorderRadius.circular(7),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                                                  child: Center(
                                                    child: controller.timeList[index]
                                                        .toString()
                                                        .primaryRegular(fontSize: 17, fontColor: AppColor.appBlackColor),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  /// NO SELECT ANY TABLE WARNING

  Future<dynamic> selectTableWarning(BuildContext context) {
    return showDialog(
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
            Padding(
                padding: const EdgeInsets.all(20),
                child: AppString.tableNotSelected.primaryRegular(fontColor: AppColor.appBlackColor, fontSize: 17)),
            const Divider(height: 0),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: const Center(
                        child: Text(
                          AppString.okay,
                          style: TextStyle(fontSize: 16, color: AppColor.appBlueColor),
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
  }

  /// CENTER CALENDER VIEW

  Widget calenderView(ReservationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10).copyWith(left: 15),
            child: AppString.date.toUpperCase().primaryRegular(fontColor: AppColor.appLightGreyColor, fontSize: 15)),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              availableGestures: AvailableGestures.none,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              focusedDay: controller.selectedDate,
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                controller.setSelectedDate(selectedDay);
              },
              headerStyle: const HeaderStyle(
                titleCentered: true,
              ),
              weekNumbersVisible: false,
              availableCalendarFormats: const {CalendarFormat.month: AppString.month},
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.grey),
                weekendStyle: TextStyle(color: Colors.grey),
              ),
              calendarBuilders: CalendarBuilders(
                weekNumberBuilder: (context, weekNumber) {
                  return const SizedBox();
                },
                defaultBuilder: (context, day, focusedDay) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: controller.selectedDate == day ? AppColor.appColor : Colors.transparent, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                              color: controller.selectedDate == day ? Colors.white : Colors.black,
                              fontSize: controller.selectedDate == day ? 15 : 13),
                        ),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.selectedDate.day == day.day && controller.selectedDate.month == day.month
                            ? AppColor.appColor
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                            color: controller.selectedDate.day == day.day && controller.selectedDate.month == day.month
                                ? Colors.white
                                : AppColor.appColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              calendarStyle: const CalendarStyle(
                selectedTextStyle: TextStyle(color: Colors.white),
                selectedDecoration: BoxDecoration(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// CONFIRMATION SHEET

  openConfirmationMenu(BuildContext context) {
    Dialog confirmationDialog = Dialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        alignment: Alignment.center,
        child: confirmationDialogContent(context));

    return showDialog(
      context: context,
      builder: (BuildContext context) => confirmationDialog,
    );
  }

  Widget confirmationDialogContent(BuildContext context) {
    return StatefulBuilder(
      builder: (c1, setState) {
        return Container(
          width: 500,
          decoration: BoxDecoration(color: AppColor.appGreyColor, borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppString.summary.primaryBold(fontColor: AppColor.appBlackColor, fontSize: 24),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8, left: 12),
                    child: AppString.bookingInfo.toUpperCase().primaryRegular(fontSize: 13, fontColor: AppColor.appLightGreyColor),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12),
                      child: Column(
                        children: [
                          commonText(AppString.nameR,
                              "${preferences.getString(SharedPreference.userFirstName)} ${preferences.getString(SharedPreference.userLastName)}"),
                          commonDivider(17),
                          commonText(AppString.emailR, "${preferences.getString(SharedPreference.userEmail)}"),
                          commonDivider(17),
                          commonText(AppString.dayR, DateFormat("dd MMMM yyyy").format(controller.selectedDate)),
                          commonDivider(17),
                          commonText(AppString.nowR, controller.selectedTime),
                          commonDivider(17),
                          commonText(AppString.peopleR, controller.people),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 10, left: 12),
                    child: AppString.restroInfo.toUpperCase().primaryRegular(fontColor: AppColor.appLightGreyColor, fontSize: 13),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 7, bottom: 10),
                      child: Column(
                        children: [
                          commonTextWithImage("", AppString.dogFriendly, Colors.white),
                          commonDivider(7),
                          commonTextWithImage(AppAssets.wifi, AppString.freeWifi, Colors.blue),
                          commonDivider(7),
                          commonTextWithImage(AppAssets.party, AppString.birthdayParty, Colors.yellow),
                          commonDivider(7),
                          commonTextWithImage(AppAssets.car, AppString.freeParking, AppColor.appColor),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 18, bottom: 10, left: 12),
                      child: AppString.specialReq.toUpperCase().primaryRegular(fontColor: AppColor.appLightGreyColor, fontSize: 13)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
                      child: Column(
                        children: [
                          TextField(
                            style: const TextStyle(fontSize: 14, color: Colors.black),
                            cursorColor: AppColor.appColor,
                            controller: controller.requestController,
                            decoration: InputDecoration(
                              hintText: AppString.write,
                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                          // commonDivider(15),
                          // Row(
                          //   children: [
                          //     const Text(
                          //       "High Chairs for Children",
                          //       style: black14w400,
                          //     ),
                          //     const Spacer(),
                          //     Container(
                          //       decoration:
                          //           BoxDecoration(color: appDividerColor, borderRadius: BorderRadius.circular(5)),
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(2),
                          //         child: Row(
                          //           children: [
                          //             switchContainer(
                          //               "0",
                          //               controller.selectedSwitch,
                          //               0,
                          //               () {
                          //                 controller.setSwitchIndex(0);
                          //                 setState(() {});
                          //               },
                          //             ),
                          //             switchContainer(
                          //               "1",
                          //               controller.selectedSwitch,
                          //               1,
                          //               () {
                          //                 controller.setSwitchIndex(1);
                          //                 setState(() {});
                          //               },
                          //             ),
                          //             switchContainer(
                          //               "2",
                          //               controller.selectedSwitch,
                          //               2,
                          //               () {
                          //                 controller.setSwitchIndex(2);
                          //                 setState(() {});
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 10,
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                  20.0.addHSpace(),
                  GestureDetector(
                    onTap: () async {
                      await controller.addBookingOnDatabase();
                      controller.clearData(true);
                      Navigator.pop(c1);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.zero,
                            backgroundColor: AppColor.appDarkGreyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    CupertinoIcons.check_mark,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 10),
                                  AppString.tableNotSelected.primaryRegular(fontColor: AppColor.appBlackColor, fontSize: 17),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      await Future.delayed(const Duration(seconds: 2)).then((value) => Navigator.pop(context));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.appColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            AppString.confirmed,
                            style: TextStyle(color: Colors.white, fontFamily: 'SfProDisplay', fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// COMMON WIDGET

  Divider commonDivider(double height) {
    return Divider(
      thickness: 0.5,
      height: height,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Row commonText(String title, text) {
    return Row(
      children: [
        title.toString().primaryRegular(fontSize: 15.5, fontColor: AppColor.appBlack1Color),
        const Spacer(),
        text.toString().primaryRegular(fontSize: 15.5, fontColor: AppColor.appBlack1Color),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  Row commonTextWithImage(String image, text, Color color) {
    return Row(
      children: [
        image == ""
            ? const SizedBox(
                height: 30,
                width: 20,
              )
            : assetImage(image, height: 30, width: 20, color: color),
        const SizedBox(
          width: 15,
        ),
        text.toString().primaryRegular(fontSize: 15.5, fontColor: AppColor.appBlack1Color),
      ],
    );
  }

  /// ADULT CHILD SWITCH

// Widget switchContainer(String title, int index, selectedIndex, Function() onTap) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       height: 25,
//       width: 35,
//       decoration: BoxDecoration(
//           color: selectedIndex == index ? Colors.white : Colors.transparent,
//           boxShadow: selectedIndex == index
//               ? [BoxShadow(offset: const Offset(2, 2), color: appGreyColor4.withOpacity(0.3), blurRadius: 4)]
//               : null,
//           borderRadius: BorderRadius.circular(5)),
//       child: Center(
//         child: Text(
//           title,
//           style: const TextStyle(color: Colors.black),
//         ),
//       ),
//     ),
//   );
// }
}
