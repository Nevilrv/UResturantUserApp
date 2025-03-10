import 'package:flutter/material.dart';
import 'package:urestaurants_user/Constant/app_color.dart';

extension Primary on String {
  Widget primaryRegular({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    int? maxLine,
    String? fontFamily,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: 'SfProDisplay',
        color: fontColor ?? AppColor.appWhiteColor,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w400,
        decoration: textDecoration ?? TextDecoration.none,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
    );
  }

  Widget primaryMedium({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    String? fontFamily,
    FontWeight? fontWeight,
    int? maxLine,
    double? letterSpacing,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        fontFamily: 'SfProDisplay',
        fontWeight: fontWeight ?? FontWeight.w500,
        color: fontColor ?? AppColor.appWhiteColor,
        fontSize: fontSize ?? 16,
        decoration: textDecoration ?? TextDecoration.none,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
      maxLines: maxLine,
    );
  }

  Widget primarySemiBold({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    String? fontFamily,
    TextAlign? textAlign,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        fontFamily: 'SfProDisplay',
        color: fontColor ?? AppColor.appWhiteColor,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w600,
        decoration: textDecoration ?? TextDecoration.none,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
    );
  }

  Widget primaryBold({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    String? fontFamily,
    int? maxLine,
    TextAlign? textAlign,
    FontWeight? fontWeight,
    double? letterSpacing,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      maxLines: maxLine,
      style: TextStyle(
        fontFamily: 'SfProDisplay',
        color: fontColor ?? AppColor.appWhiteColor,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.w700,
        decoration: textDecoration ?? TextDecoration.none,
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign,
    );
  }
}
