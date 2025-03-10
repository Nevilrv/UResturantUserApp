import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/app_color.dart';

class StatusBarColorChange {
  static void defaultColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: CupertinoColors.systemGrey6,
        systemNavigationBarColor: AppColor.appGreyColor,
        systemNavigationBarDividerColor: AppColor.appGreyColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  static void bottomBarColor() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color (change as needed)
      statusBarIconBrightness: Brightness.light, // Set icon brightness (light or dark)
    ));
  }
}
