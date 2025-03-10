import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:urestaurants_user/Constant/app_color.dart';

class AppAssets {
  static const imagePath = "assets/images/";

  static const pizzaImg = "${imagePath}food.png";
  static const hotel = "${imagePath}hotel.png";
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
                  color: appDarkGreyColor,
                  child: Center(
                    child: Text(name ?? ""),
                  ));
        },
        placeholder: (context, url) {
          return Shimmer.fromColors(
            baseColor: appDarkGreyColor,
            highlightColor: appLightGreyColor,
            child: Container(
              color: appDarkGreyColor,
            ),
          );
        },
        fit: boxFit ?? BoxFit.fill,
        imageUrl: url),
  );
}
