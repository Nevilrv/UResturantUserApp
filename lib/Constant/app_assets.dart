import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:urestaurants_user/Constant/app_color.dart';

class AppAssets {
  static const imagePath = "assets/images/";

  static const pizzaImg = "${imagePath}food.png";
  static const star = "${imagePath}star.png";
  static const uk = "${imagePath}uk.png";
  static const us = "${imagePath}us.png";
  static const chinese = "${imagePath}chinese.png";
  static const polish = "${imagePath}polish.png";
  static const euro = "${imagePath}euro.png";
  static const wifi = "${imagePath}wi-fi.png";
  static const party = "${imagePath}party.png";
  static const car = "${imagePath}car.png";
  static const google = "${imagePath}google.png";
  static const bell = "${imagePath}bell.png";
  static const foodDelivery = "${imagePath}food-delivery.png";
  static const parking = "${imagePath}parking.png";
  static const loginBg = "${imagePath}login_bg.jpg";
  static const hotelImage = "${imagePath}01.jpg";
}

Widget assetImage(String image, {double? height, double? width, Color? color, double? scale}) {
  return Image.asset(
    image,
    height: height,
    width: width,
    color: color,
    scale: scale,
  );
}

AssetImage assetsImage2(String image, {double? height, double? width, Color? color}) {
  return AssetImage(image);
}

Widget cachedNetworkImage({
  required String url,
  double? radius,
  BoxFit? boxFit,
  Widget? errorWidget,
  double? width,
  double? height,
  required String name,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius ?? 10),
    child: CachedNetworkImage(
        width: width,
        height: height,
        errorWidget: (context, url, error) {
          return errorWidget ??
              Container(
                width: width,
                height: height,
                color: AppColor.appDarkGreyColor,
                child: Center(
                  child: Text(name ?? ""),
                ),
              );
        },
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: AppColor.appDarkGreyColor,
            highlightColor: AppColor.appLightGreyColor,
            child: Container(
              color: AppColor.appDarkGreyColor,
            ),
          );
        },
        fit: boxFit ?? BoxFit.fill,
        imageUrl: url),
  );
}

Widget assetImageWithPlaceHolder({
  required String url,
  double? radius,
  BoxFit? boxFit,
  Widget? errorWidget,
  double? width,
  double? height,
  required String name,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius ?? 10),
    child: Image.asset(
      url,
      width: width,
      height: height,
      fit: boxFit ?? BoxFit.fill,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColor.appDarkGreyColor,
              child: Center(
                child: Text(name),
              ),
            );
      },
    ),
  );
}
