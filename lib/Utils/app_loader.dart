import 'package:flutter/material.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:vibration/vibration.dart';

class AppLoader {
  loader() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColor.appBlueColor,
      ),
    );
  }
}

class HapticFeedBack {
  static Future buttonClick() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(
        duration: 50,
      );
    } else {
      print("Device does not support vibration");
    }
  }

  static Future onError() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(
        duration: 200,
      );
    } else {
      print("Device does not support vibration");
    }
  }
}
