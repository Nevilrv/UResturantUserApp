import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_string.dart';
import 'package:urestaurants_user/Utils/extention.dart';

import '../../Constant/app_color.dart';

class ParkingScreen extends StatelessWidget {
  const ParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: (AppString.parking).primaryMedium(fontSize: 30, fontWeight: FontWeight.w600, fontColor: AppColor.appBlackColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          width: w,
          height: h * 0.7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage(
                    AppAssets.parking,
                  ),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Container(
                width: w,
                height: 70,
                margin: EdgeInsets.only(top: 70),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                ),
                child: Center(
                  child: "2 2 8 8 E".primaryMedium(fontColor: AppColor.appBlackColor, fontSize: 27.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
