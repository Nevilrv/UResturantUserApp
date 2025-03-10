import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/MenuScreen/controller/menu_screen_controller.dart';

import '../../Constant/app_string.dart';
import 'Model/item_data_model.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  MenuPageController menuController = Get.find();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<MenuPageController>(
      builder: (controller) {
        return controller.fetchDataLoader
            ? Container(
                color: AppColor.appGreyColor,
                child: AppLoader().loader(),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 180,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: AppColor.appGreyColor,
                    pinned: true,
                    title: controller.getHeader(controller.selectedIndex2).primarySemiBold(fontSize: 30, fontColor: AppColor.appBlackColor),
                    flexibleSpace: FlexibleSpaceBar(
                      background: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 10),
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.sectionDataModel?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              HapticFeedBack.buttonClick();
                              controller.updateMenuName(index);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cachedNetworkImage(
                                    url: controller.sectionDataModel?[index].imageUrl ?? "",
                                    name: controller.sectionDataModel?[index].name ?? "",
                                    height: 78,
                                    width: 158),
                                10.0.addHSpace(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: controller.getHeader(index).primaryMedium(fontSize: 17, fontColor: AppColor.appBlackColor),
                                ),
                              ],
                            ),
                          ).paddingOnly(right: 15);
                        },
                      ),
                    ).paddingOnly(top: 60),
                  ),
                  if (controller.mainData.isEmpty)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Text(
                            controller.message,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      childCount: controller.mainData.length,
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.sectionDataModel?[controller.selectedIndex2].name != "Dolci")
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10),
                                  child: Builder(builder: (context) {
                                    return controller.mainData[index]["title"]
                                        .toString()
                                        .toUpperCase()
                                        .trim()
                                        .replaceAll('     ', '')
                                        .primaryMedium(fontColor: AppColor.appLightGreyColor, fontSize: 15);
                                  }),
                                ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.mainData[index]["data"].length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, itemIndex) {
                                    ItemDataModel data = controller.mainData[index]["data"][itemIndex];
                                    if (data.ingredienti
                                        .toString()
                                        .trim()
                                        .toLowerCase()
                                        .contains(controller.textController.text.toString().trim().toLowerCase())) {
                                      return controller.sectionDataModel?[controller.selectedIndex2].name == "Dolci"
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 170,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      image: DecorationImage(image: AssetImage(data.imageAVAL ?? ""), fit: BoxFit.cover)),
                                                ),
                                                7.0.addHSpace(),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    "${data.the000Nome}".primarySemiBold(fontColor: AppColor.appBlackColor, fontSize: 22),
                                                    "€ ${data.priceD}".primaryRegular(fontColor: AppColor.appGreyColor5, fontSize: 12),
                                                  ],
                                                ).paddingOnly(left: 15)
                                              ],
                                            ).paddingSymmetric(vertical: 13)
                                          : GestureDetector(
                                              onTap: () {
                                                HapticFeedBack.buttonClick();
                                                List<int> indexList = [index, itemIndex];
                                                if (indexList.join(",") == controller.selectedIndex.join(",")) {
                                                  controller.updateSelectedIndex([], "");
                                                } else {
                                                  controller.updateSelectedIndex(indexList, data.allergeni?.replaceAll(".", "") ?? "");
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(vertical: 13),
                                                    color: controller.selectedIndex.isEmpty
                                                        ? AppColor.appWhiteColor
                                                        : controller.selectedIndex[0] == index && controller.selectedIndex[1] == itemIndex
                                                            ? AppColor.appGreyColor4
                                                            : AppColor.appWhiteColor,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 13),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 12,
                                                                child: Builder(builder: (context) {
                                                                  return Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      (controller.selectedIndex.isEmpty
                                                                              ? controller.getTitle(index, itemIndex)
                                                                              : controller.selectedIndex[0] == index &&
                                                                                      controller.selectedIndex[1] == itemIndex
                                                                                  ? controller.getTitle(index, itemIndex, local: "it")
                                                                                  : controller.getTitle(index, itemIndex))
                                                                          .primaryRegular(fontSize: 17, fontColor: AppColor.appBlackColor),
                                                                      if (data.ingredienti?.isNotEmpty ?? false)
                                                                        (controller.selectedIndex.isEmpty
                                                                                ? controller.getSubTitle(index, itemIndex)
                                                                                : controller.selectedIndex[0] == index &&
                                                                                        controller.selectedIndex[1] == itemIndex
                                                                                    ? controller.getSubTitle(index, itemIndex, local: "it")
                                                                                    : controller.getSubTitle(index, itemIndex))
                                                                            .primaryRegular(
                                                                                fontColor: AppColor.appGrey3Color,
                                                                                fontSize: 17,
                                                                                textOverflow: TextOverflow.clip),
                                                                      data.imageAVAL != null
                                                                          ? controller.selectedIndex.isEmpty
                                                                              // ? price(controller, data)
                                                                              ? Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    if (data.priceD?.isNotEmpty ?? false)
                                                                                      "€ ${data.priceD}".primaryRegular(
                                                                                          fontSize: 17, fontColor: AppColor.appBlackColor),
                                                                                    if (data.priceM?.isNotEmpty ?? false)
                                                                                      "€ ${data.priceM}".primaryRegular(
                                                                                          fontSize: 17, fontColor: AppColor.appBlackColor),
                                                                                  ],
                                                                                )
                                                                              : controller.selectedIndex[0] == index &&
                                                                                      controller.selectedIndex[1] == itemIndex
                                                                                  ? const SizedBox()
                                                                                  // : price(controller, data)
                                                                                  : Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        if (data.priceD?.isNotEmpty ?? false)
                                                                                          "€ ${data.priceD}".primaryRegular(
                                                                                              fontSize: 17,
                                                                                              fontColor: AppColor.appBlackColor),
                                                                                        if (data.priceM?.isNotEmpty ?? false)
                                                                                          "€ ${data.priceM}".primaryRegular(
                                                                                              fontSize: 17,
                                                                                              fontColor: AppColor.appBlackColor),
                                                                                      ],
                                                                                    )
                                                                          : const SizedBox(),
                                                                    ],
                                                                  );
                                                                }),
                                                              ),
                                                              data.imageAVAL == null
                                                                  ? Expanded(
                                                                      flex: 4,
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                                        children: [
                                                                          if (data.priceD?.isNotEmpty ?? false)
                                                                            "€ ${data.priceD}".primaryRegular(
                                                                                fontSize: 17, fontColor: AppColor.appBlackColor),
                                                                          if (data.priceM?.isNotEmpty ?? false)
                                                                            "€ ${data.priceM}".primaryRegular(
                                                                                fontSize: 17, fontColor: AppColor.appBlackColor),
                                                                        ],
                                                                      ),
                                                                      // child: price(controller, data),
                                                                    )
                                                                  : controller.selectedIndex.isEmpty
                                                                      ? assetImageWithPlaceHolder(
                                                                          url: data.imageAVAL ?? "",
                                                                          height: 08.h,
                                                                          width: 12.h,
                                                                          name: 'asd',
                                                                        )
                                                                      : (controller.selectedIndex[0] == index &&
                                                                              controller.selectedIndex[1] == itemIndex)
                                                                          ? Expanded(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  if (data.priceD?.isNotEmpty ?? false)
                                                                                    "€ ${data.priceD}".primaryRegular(
                                                                                        fontSize: 17, fontColor: AppColor.appBlackColor),
                                                                                  if (data.priceM?.isNotEmpty ?? false)
                                                                                    "€ ${data.priceM}".primaryRegular(
                                                                                        fontSize: 17, fontColor: AppColor.appBlackColor),
                                                                                ],
                                                                              ),
                                                                              // child: price(controller, data),
                                                                            )
                                                                          : (data.imageAVAL != null)
                                                                              ? Builder(builder: (context) {
                                                                                  debugPrint(
                                                                                      'data.imageAVAL::::::::::::::::${data.imageAVAL}');
                                                                                  return assetImageWithPlaceHolder(
                                                                                      url: data.imageAVAL ?? "",
                                                                                      height: 08.h,
                                                                                      width: 12.h,
                                                                                      name: 'sadsadsad');
                                                                                })
                                                                              : Expanded(
                                                                                  flex: 4,
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                    children: [
                                                                                      if (data.priceD?.isNotEmpty ?? false)
                                                                                        "€ ${data.priceD}".primaryRegular(
                                                                                            fontSize: 17,
                                                                                            fontColor: AppColor.appBlackColor),
                                                                                      if (data.priceM?.isNotEmpty ?? false)
                                                                                        "€ ${data.priceM}".primaryRegular(
                                                                                            fontSize: 17,
                                                                                            fontColor: AppColor.appBlackColor),
                                                                                    ],
                                                                                  ),
                                                                                  // child: price(controller, data),
                                                                                ),
                                                            ],
                                                          ),
                                                          if (controller.selectedIndex.isNotEmpty && controller.allergyImageList.isNotEmpty)
                                                            Visibility(
                                                              visible: controller.selectedIndex[0] == index &&
                                                                  controller.selectedIndex[1] == itemIndex,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                child: Row(
                                                                  children: List.generate(
                                                                    controller.allergyImageList.length,
                                                                    (imageIndex) => Center(
                                                                      child: Image.asset(
                                                                        "assets/images/allergies/${controller.allergyImageList[imageIndex]}",
                                                                        height: 30,
                                                                        width: 30,
                                                                      ),
                                                                    ).paddingOnly(right: 10),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  if (itemIndex != controller.mainData[index]["data"].length - 1)
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 13),
                                                      color: AppColor.appDividerColor,
                                                      height: 1,
                                                      width: double.infinity,
                                                    ),
                                                ],
                                              ),
                                            );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ))
                ],
              );
      },
    );
  }

  PopupMenuButton<String> price(
    MenuPageController controller,
    /*ItemDataModel data*/
  ) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: AppColor.appGreyColor2.withOpacity(0.90),
      onSelected: (String value) {
        controller.toggleSelection(value);
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            padding: EdgeInsets.zero,
            child: Container(
              width: 220,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: AppString.toGliAllErgEne.primaryRegular(fontColor: AppColor.appLightGreyColor, fontSize: 10)),
                  const Divider(color: AppColor.appDividerColor),
                  Column(
                    children: List.generate(
                      controller.countryRs.length,
                      (index) {
                        final country = controller.countryRs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.toggleSelection(country);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Row(
                                  children: [
                                    assetImage(controller.map[index], height: 15, width: 15),
                                    country.primaryRegular(fontSize: 14, fontColor: AppColor.appWhiteColor)
                                  ],
                                ),
                              ),
                            ),
                            if (index != controller.countryRs.length - 1) const Divider(color: AppColor.appDividerColor),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      /*child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (data.priceD?.isNotEmpty ?? false)
            Text(
              "€ ${data.priceD}",
              style: black17w400,
            ),
          if (data.priceM?.isNotEmpty ?? false)
            Text(
              "€ ${data.priceM}",
              style: black17w400,
            )
        ],
      ),*/
    );
  }

  Widget searchBar(MenuPageController controller) {
    return GestureDetector(
      onTap: controller.toggleSearch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 40,
        width: controller.isTapped ? 220 : 80,
        decoration: BoxDecoration(
          color: AppColor.appDarkGreyColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
                color: AppColor.appLightGreyColor,
                size: 20,
              ),
            ),
            Expanded(
              child: controller.isTapped
                  ? TextField(
                      cursorColor: AppColor.appGreyColor2,
                      controller: controller.textController,
                      onChanged: controller.updateSearchText,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(horizontal: 3),
                      ),
                      style: const TextStyle(color: AppColor.appWhiteColor, fontSize: 14, fontFamily: 'SfProDisplay'),
                    )
                  : const SizedBox.shrink(),
            ),
            controller.textController.text.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        controller.textController.clear();
                        controller.updateSearchText('');
                      },
                      child: const Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: AppColor.appGreyColor2,
                        size: 14,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget menuButton(MenuPageController controller) {
    return Container(
      height: 4.h,
      width: 10.5.w,
      decoration: BoxDecoration(
        color: AppColor.appDarkGreyColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.more_horiz,
          color: AppColor.appLightGreyColor,
        ),
        color: AppColor.appGreyColor2.withOpacity(0.90),
        onSelected: (String value) {
          controller.toggleSelection(value);
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              child: Container(
                width: 220,
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: AppString.toGliAllErgEne.primaryRegular(fontColor: AppColor.appLightGreyColor, fontSize: 10)),
                    const Divider(color: AppColor.appDividerColor),
                    Column(
                      children: List.generate(
                        controller.popPopName.length,
                        (index) {
                          final itemName = controller.popPopName[index];
                          return Padding(
                            padding: EdgeInsets.zero,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.toggleSelection(itemName);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      children: [
                                        itemName.toString().primaryRegular(
                                            fontSize: 14,
                                            fontColor: controller.selectedItems.contains(itemName)
                                                ? AppColor.appRedColor
                                                : AppColor.appWhiteColor),
                                        const Spacer(),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                            color: AppColor.appWhiteColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (index != controller.popPopName.length - 1) const Divider(color: AppColor.appDividerColor),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
      ),
    );
  }
}
