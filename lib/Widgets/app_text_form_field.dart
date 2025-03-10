import 'package:flutter/material.dart';

import '../Constant/app_color.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField(
      {super.key, this.isDense, this.hintText, this.controller, this.paddingBottom, this.paddingTop, this.obscureText, this.textSize});
  final bool? isDense;
  final String? hintText;
  final TextEditingController? controller;
  final double? paddingBottom;
  final double? paddingTop;
  final bool? obscureText;
  final double? textSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom ?? 0, top: paddingTop ?? 0),
      child: TextFormField(
        controller: controller,
        cursorHeight: 20,
        obscureText: obscureText ?? false,
        cursorColor: AppColor.appColor,
        cursorWidth: 1.5,
        style: TextStyle(color: Colors.black, fontSize: textSize ?? 16, fontFamily: 'SfProDisplay', fontWeight: FontWeight.w400),
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: hintText ?? "",
            hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.5), fontSize: textSize ?? 16, fontFamily: 'SfProDisplay', fontWeight: FontWeight.w400),
            isDense: isDense ?? false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2)),
      ),
    );
  }
}
