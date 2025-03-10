import 'package:flutter/material.dart';
import 'package:urestaurants_user/Constant/app_color.dart';

class AppLoader {
  loader() {
    return const Center(
      child: CircularProgressIndicator(
        color: appBlueColor,
      ),
    );
  }
}
