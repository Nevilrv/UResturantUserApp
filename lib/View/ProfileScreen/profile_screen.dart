import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/InfoScreen/controller/info_controller.dart';
import 'package:urestaurants_user/Widgets/app_material_button.dart';

import '../../Constant/app_color.dart';
import '../../Constant/app_string.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  InfoController infoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        leadingWidth: 80,
        leading: GestureDetector(
          onTap: () {
            HapticFeedBack.buttonClick();
            Get.back();
          },
          child: Row(
            children: [
              const Icon(
                Icons.chevron_left_rounded,
                color: AppColor.appBlueColor,
                size: 30,
              ),
              AppString.back.primaryRegular(fontColor: AppColor.appBlueColor, fontSize: 14)
            ],
          ),
        ),
        title: ("Account").primaryMedium(fontColor: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            3.h.addHSpace(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "INFO"
                    .primaryRegular(fontWeight: FontWeight.w300, fontColor: AppColor.appGrey1Color, fontSize: 12)
                    .paddingOnly(left: 10, bottom: 5),
                Container(
                  // height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Nome :   ${preferences.getString(SharedPreference.userFirstName)} ${preferences.getString(SharedPreference.userLastName)}"
                          .primaryMedium(fontColor: AppColor.appBlack1Color, fontSize: 15, fontWeight: FontWeight.w200),
                      const Divider(
                        color: AppColor.appDividerColor,
                        height: 25,
                      ),
                      "${AppString.email} :  ${preferences.getString(SharedPreference.userEmail)}"
                          .primaryMedium(fontColor: AppColor.appBlack1Color, fontSize: 15, fontWeight: FontWeight.w200),
                      const Divider(
                        color: AppColor.appDividerColor,
                        height: 25,
                      ),
                      "Telefono :   +39 5855".primaryMedium(fontColor: AppColor.appBlack1Color, fontSize: 15, fontWeight: FontWeight.w200),
                    ],
                  ),
                )
              ],
            ),
            4.h.addHSpace(),
            Container(
              // height: 100,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: "Note Legali".primaryMedium(fontColor: AppColor.appColor, fontSize: 15, fontWeight: FontWeight.w200),
            ),
            4.h.addHSpace(),
            AppMaterialButton(
              btnColor: AppColor.appRedColor,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                preferences.logOut();
                Get.back();
              },
              isShaddow: false,
              fontSize: 20,
              text: "Esci",
            ),
            3.h.addHSpace(),
            TextButton(
                onPressed: () {
                  infoController.deleteUserAccount();
                },
                child: "Elimina Account".primaryMedium(fontColor: AppColor.appBlack1Color, fontSize: 15, fontWeight: FontWeight.w200)),
          ],
          // CupertinoFormSection
        ),
      ),
    );
  }
}
