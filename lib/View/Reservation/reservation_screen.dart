import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/app_textstyle.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/Utils/app_responsive.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/View/Reservation/reservation_controller.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  ReservationController controller = Get.put(ReservationController());

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    await preferences.putString(SharedPreference.currentPage, "reservation");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReservationController>(
      builder: (controller) {
        return SingleChildScrollView(
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
                  screenTitleText(),
                  buildSizedBoxH(5),
                  numberListView(controller),
                  buildSizedBoxH(15),
                  calenderView(controller),
                  buildSizedBoxH(15),
                  timeSelectionView(controller, context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding screenTitleText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Booking",
        style: black30w600,
      ),
    );
  }

  Column timeSelectionView(ReservationController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Time".toUpperCase(),
            style: grey15w400appLightGreyColor,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            children: List.generate(
              controller.timeList.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      controller.selectNumber != 0 ? openDialog(context) : null;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.selectNumber == 0 ? appGrey3Color : appColor,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        child: Center(
                          child: Text(
                            controller.timeList[index].toString(),
                            style: black15w400.copyWith(color: Colors.white),
                          ),
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
    );
  }

  Column calenderView(ReservationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Date".toUpperCase(),
            style: grey15w400appLightGreyColor,
          ),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                controller.setSelectedDate(selectedDay);
                debugPrint('selectedDay==========>>>>>$selectedDay');
              },
              headerStyle: const HeaderStyle(
                titleCentered: true,
              ),
              weekNumbersVisible: false,
              availableCalendarFormats: const {CalendarFormat.month: "Month"},
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
                          color: controller.selectedDate == day ? appColor : Colors.transparent,
                          shape: BoxShape.circle),
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
                              ? appColor
                              : Colors.transparent,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                              color:
                                  controller.selectedDate.day == day.day && controller.selectedDate.month == day.month
                                      ? Colors.white
                                      : appColor,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
              calendarStyle: const CalendarStyle(
                  selectedTextStyle: TextStyle(color: Colors.white),
                  selectedDecoration: BoxDecoration(color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }

  Column numberListView(ReservationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Numbers of people".toUpperCase(),
            style: grey15w400appLightGreyColor,
          ),
        ),
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
                      height: 35,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: controller.numbers[index] == controller.selectNumber
                              ? Border.all(color: appColor, width: 3)
                              : null),
                      child: Center(
                        child: Text(
                          controller.numbers[index].toString(),
                          style: black15w400.copyWith(fontSize: 17),
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
    );
  }

  openDialog(BuildContext context) {
    Dialog dialog = Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      alignment: Alignment.center, //this right here
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: 500,
            decoration: BoxDecoration(color: appGreyColor, borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Summary",
                      style: black30w600.copyWith(fontSize: 22),
                    ),
                    buildSizedBoxH(15),
                    Text(
                      "Booking info".toUpperCase(),
                      style: grey15w400appLightGreyColor,
                    ),
                    buildSizedBoxH(10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        child: Column(
                          children: [
                            commonText("Name:", "Nevil Vaghasiya"),
                            commonDivider(12),
                            commonText("Email:", "vaghasiyanevil9120@gmail.com"),
                            commonDivider(12),
                            commonText("Day:", "05 january 2025"),
                            commonDivider(12),
                            commonText("Now:", "12:30"),
                            commonDivider(12),
                            commonText("People:", "2 Adulti"),
                          ],
                        ),
                      ),
                    ),
                    buildSizedBoxH(15),
                    Text(
                      "Info restaurants".toUpperCase(),
                      style: grey15w400appLightGreyColor,
                    ),
                    buildSizedBoxH(10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        child: Column(
                          children: [
                            commonTextWithImage("", "Dog friendly", Colors.white),
                            commonDivider(5),
                            commonTextWithImage(AppAssets.wifi, "Free Wifi", Colors.blue),
                            commonDivider(5),
                            commonTextWithImage(AppAssets.party, "Birthday / Party", Colors.yellow),
                            commonDivider(5),
                            commonTextWithImage(AppAssets.car, "Free Parking", appColor),
                          ],
                        ),
                      ),
                    ),
                    buildSizedBoxH(15),
                    Text(
                      "Special request".toUpperCase(),
                      style: grey15w400appLightGreyColor,
                    ),
                    buildSizedBoxH(10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        child: Column(
                          children: [
                            TextField(
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                              cursorColor: appColor,
                              decoration: InputDecoration(
                                  hintText: "Write..",
                                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none),
                            ),
                            commonDivider(15),
                            Row(
                              children: [
                                const Text(
                                  "High Chairs for Children",
                                  style: black14w400,
                                ),
                                const Spacer(),
                                Container(
                                  decoration:
                                      BoxDecoration(color: appDividerColor, borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Row(
                                      children: [
                                        switchContainer(
                                          "0",
                                          controller.selectedSwitch,
                                          0,
                                          () {
                                            controller.setSwitchIndex(0);
                                            setState(() {});
                                          },
                                        ),
                                        switchContainer(
                                          "1",
                                          controller.selectedSwitch,
                                          1,
                                          () {
                                            controller.setSwitchIndex(1);
                                            setState(() {});
                                          },
                                        ),
                                        switchContainer(
                                          "2",
                                          controller.selectedSwitch,
                                          2,
                                          () {
                                            controller.setSwitchIndex(2);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    buildSizedBoxH(20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: appColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            "Confirmed",
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
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
      ),
    );
    return showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  Widget switchContainer(String title, int index, selectedIndex, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 25,
        width: 35,
        decoration: BoxDecoration(
            color: selectedIndex == index ? Colors.white : Colors.transparent,
            boxShadow: selectedIndex == index
                ? [BoxShadow(offset: const Offset(2, 2), color: appGreyColor4.withOpacity(0.3), blurRadius: 4)]
                : null,
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

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
        Text(
          title.toString(),
          style: black14w400,
        ),
        const Spacer(),
        Text(
          text.toString(),
          style: black14w400,
        ),
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
          width: 10,
        ),
        Text(
          text.toString(),
          style: black14w400,
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
