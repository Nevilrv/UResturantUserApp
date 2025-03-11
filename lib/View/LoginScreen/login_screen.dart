import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/app_string.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/LoginScreen/login_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginScreenController loginScreenController = Get.put(LoginScreenController());
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.3,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.0.addHSpace(),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: CircleAvatar(
                backgroundColor: AppColor.appGreyColor5.withValues(alpha: 0.3),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColor.appGreyColor2,
                ),
                radius: 15,
              ),
            ),
          ),
          "Login".primarySemiBold(fontSize: 30, fontColor: AppColor.appBlackColor),
          Spacer(),
          "You must login to Confirm the booking".primaryRegular(fontSize: 16, fontColor: AppColor.appBlackColor),
          Spacer(),
          GetBuilder<LoginScreenController>(builder: (controller) {
            return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: GestureDetector(
                  onTap: () async {
                    await controller.googleSignIn(context: context);
                  },
                  child: Container(
                    width: w,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.appBlackColor,
                    ),
                    child: controller.googleSignLoader
                        ? Center(
                            child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              assetImage(AppAssets.google, height: 25, width: 25),
                              const SizedBox(
                                width: 15,
                              ),
                              AppString.signInWithGoogle.primaryRegular(
                                fontSize: 20,
                                fontColor: Colors.white,
                              ),
                            ],
                          ),
                  ),
                ));
          }),
          Spacer(),
        ],
      ).paddingSymmetric(horizontal: 15),
    );
  }
}
