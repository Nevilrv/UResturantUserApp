import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/new_order_screen_controller.dart';
import 'package:urestaurants_user/View/OrderScreen/widget/iteam_type_widget.dart';

class MaxiDialog extends StatelessWidget {
  MaxiDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewOrderScreenController>(builder: (controller) {
      return PullDownButton(
        itemBuilder: (context) => [
          PullDownMenuItem(
            onTap: () async {
              controller.updateSelectedType(type: ItemType.maxi1, index: 1);
            },
            title: 'Maxi 1 Gusto',
            itemTheme:
                const PullDownMenuItemTheme(textStyle: TextStyle(color: AppColor.appBlackColor, fontSize: 16, fontFamily: 'SfProDisplay')),
          ),
          PullDownMenuItem(
            onTap: () async {
              controller.updateSelectedType(type: ItemType.maxi2, index: 1);
            },
            title: 'Maxi 2 Gusto',
            itemTheme:
                const PullDownMenuItemTheme(textStyle: TextStyle(color: AppColor.appBlackColor, fontSize: 16, fontFamily: 'SfProDisplay')),
          ),
          PullDownMenuItem(
            onTap: () async {
              controller.updateSelectedType(type: ItemType.maxi3, index: 1);
            },
            title: 'Maxi 3 Gusto',
            itemTheme:
                const PullDownMenuItemTheme(textStyle: TextStyle(color: AppColor.appBlackColor, fontSize: 16, fontFamily: 'SfProDisplay')),
          ),
          PullDownMenuItem(
            onTap: () async {
              controller.updateSelectedType(type: ItemType.maxi4, index: 1);
            },
            title: 'Maxi 4 Gusto',
            itemTheme:
                const PullDownMenuItemTheme(textStyle: TextStyle(color: AppColor.appBlackColor, fontSize: 16, fontFamily: 'SfProDisplay')),
          ),
        ],
        buttonBuilder: (context, showMenu) => ItemTypeWidget(
          selectedIndex: controller.selectedIndex,
          index: 1,
          title: "Maxi",
          onTap: () {
            if (controller.checkValidationForChangeItemType() == true) {
              showMenu();
            } else {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Attenzione"),
                  content: const Text("È necessario concludere la combinazione della pizza."),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        "OK",
                        style: TextStyle(fontSize: 16, color: AppColor.appColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      );
    });
  }
}
