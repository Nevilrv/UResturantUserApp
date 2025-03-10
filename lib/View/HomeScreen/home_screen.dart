import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Ai Trancentino".primarySemiBold(fontColor: AppColor.appBlackColor, fontSize: 25),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(color: AppColor.appWhiteColor),
                  child: Column(),
                );
              },
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 10);
    });
  }
}
