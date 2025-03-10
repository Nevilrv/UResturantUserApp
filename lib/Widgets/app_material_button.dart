import 'package:flutter/material.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/extention.dart';

import '../constant/app_color.dart';

class AppMaterialButton extends StatelessWidget {
  const AppMaterialButton(
      {super.key, this.btnColor, this.text, this.textColor, this.onPressed, this.fontSize, this.isShaddow = true, this.height});
  final Color? btnColor;
  final String? text;
  final Color? textColor;
  final double? fontSize;
  final bool? isShaddow;
  final void Function()? onPressed;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        HapticFeedBack.buttonClick();
        onPressed?.call();
      },
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7.0))),
      minWidth: double.infinity,
      color: btnColor ?? AppColor.appBlueColor,
      elevation: isShaddow == true ? 2 : 0,
      height: height ?? 45,
      child: (text ?? "").primaryMedium(fontSize: fontSize ?? 20, fontColor: textColor ?? AppColor.appWhiteColor),
    );
  }
}
