import 'package:flutter/material.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/extention.dart';

class ItemTypeWidget extends StatelessWidget {
  const ItemTypeWidget({
    super.key,
    this.onTap,
    required this.selectedIndex,
    required this.index,
    required this.title,
  });
  final void Function()? onTap;
  final int selectedIndex;
  final int index;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: selectedIndex == index
                ? Border.all(
                    color: index == 0
                        ? AppColor.appColor
                        : index == 1
                            ? AppColor.appOrangeColor
                            : index == 2
                                ? AppColor.appRedColor
                                : Colors.yellow,
                    width: 1.5)
                : null),
        child: title.primaryMedium(fontColor: AppColor.appBlackColor),
      ),
    );
  }
}
