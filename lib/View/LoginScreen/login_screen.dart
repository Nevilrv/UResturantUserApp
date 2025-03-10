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
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: w,
              height: h,
              child: Image.asset(
                AppAssets.loginBg,
                fit: BoxFit.cover,
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                75.0.addHSpace(),
                ("Benvenuto").primarySemiBold(fontSize: 32, fontWeight: FontWeight.w600, fontColor: AppColor.appBlackColor),
                const Spacer(),
                GetBuilder<LoginScreenController>(builder: (controller) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
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
                    ),
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
