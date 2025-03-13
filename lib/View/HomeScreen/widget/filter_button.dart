import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({super.key, required this.onChanged, required this.data});
  final Function(int) onChanged;
  final Set<String> data;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      position: PullDownMenuPosition.automatic,
      itemsOrder: PullDownMenuItemsOrder.downwards,
      itemBuilder: (context) => List.generate(
        widget.data.length,
        (index) {
          log('index::::::::::::::::${index}');
          return PullDownMenuItem(
            onTap: () {
              widget.onChanged.call(index);
            },
            title: widget.data.elementAt(index),
            itemTheme: const PullDownMenuItemTheme(
                textStyle: TextStyle(
              color: AppColor.appBlackColor,
              fontSize: 16,
              fontFamily: 'SfProDisplay',
            )),
          );
        },
      ),
      buttonBuilder: (context, showMenu) => GestureDetector(
        onTap: showMenu,
        child: Row(
          children: [
            10.0.addWSpace(),
            Icon(
              CupertinoIcons.location_fill,
              color: AppColor.appColor,
            ),
            5.0.addWSpace(),
            "All".primaryRegular(fontColor: AppColor.appColor)
          ],
        ),
      ),
    );
  }
}
