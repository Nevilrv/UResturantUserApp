import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Constant/app_assets.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/app_textstyle.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/reservation_config.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_responsive.dart';
import 'package:urestaurants_user/View/MenuPage/Model/item_data_model.dart';
import 'package:urestaurants_user/View/MenuPage/menu_controller.dart';
import 'package:urestaurants_user/constant/app_string.dart';
import 'package:urestaurants_user/utils/app_sizebox.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  MenuPageController menuController = Get.put(MenuPageController());

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    await preferences.putString(SharedPreference.currentPage, "menu");
    await menuController.fetchSectionData();
    await ReservationConfig(isActive: (p0) => false).getReservationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuPageController>(
      builder: (controller) {
        return controller.fetchDataLoader
            ? Container(
                color: appGreyColor,
                child: AppLoader().loader(),
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: Responsive.isMobile(context) ? 180 : 235,
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: appGreyColor,
                    pinned: true,
                    title: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Responsive.isTablet(context)
                              ? Responsive.width(context) / 10
                              : Responsive.isDesktop(context)
                                  ? Responsive.width(context) / 4
                                  : Responsive.is4k(context)
                                      ? Responsive.width(context) / 3.5
                                      : 0),
                      child: Row(
                        children: [
                          Text(
                            controller.getHeader(controller.selectedIndex2),
                            style: black30w600,
                          ),
                          const Spacer(),
                          buildSizedBoxW(1.5.w),
                          searchBar(controller),
                        ],
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Responsive.isTablet(context)
                                ? Responsive.width(context) / 10
                                : Responsive.isDesktop(context)
                                    ? Responsive.width(context) / 4
                                    : Responsive.is4k(context)
                                        ? Responsive.width(context) / 3.5
                                        : 0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 10),
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.sectionDataModel?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.updateMenuName(index);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  cachedNetworkImage(
                                    url: controller.sectionDataModel?[index].imageUrl ?? "",
                                    height: Responsive.isMobile(context) ? 78 : 130,
                                    width: Responsive.isMobile(context) ? 158 : 220,
                                    name: controller.sectionDataModel?[index].name ?? "",
                                  ),
                                  buildSizedBoxH(10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      controller.getHeader(index),
                                      style: black15w400.copyWith(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ).paddingOnly(right: 15);
                          },
                        ),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: Responsive.isTablet(context)
                                  ? Responsive.width(context) / 10
                                  : Responsive.isDesktop(context)
                                      ? Responsive.width(context) / 4
                                      : Responsive.is4k(context)
                                          ? Responsive.width(context) / 3.5
                                          : 0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10),
                                  child: Builder(builder: (context) {
                                    return Text(
                                      controller.mainData[index]["title"]
                                          .toString()
                                          .toUpperCase()
                                          .trim()
                                          .replaceAll('     ', ''),
                                      style: grey15w400appLightGreyColor,
                                    );
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
                                        return GestureDetector(
                                          onTap: () {
                                            List<int> indexList = [index, itemIndex];
                                            if (indexList.join(",") == controller.selectedIndex.join(",")) {
                                              controller.updateSelectedIndex([], "");
                                            } else {
                                              controller.updateSelectedIndex(
                                                  indexList, data.allergeni?.replaceAll(".", "") ?? "");
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(vertical: 13),
                                                color: controller.selectedIndex.isEmpty
                                                    ? appWhiteColor
                                                    : controller.selectedIndex[0] == index &&
                                                            controller.selectedIndex[1] == itemIndex
                                                        ? appGreyColor4
                                                        : appWhiteColor,
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
                                                                  Text(
                                                                    controller.selectedIndex.isEmpty
                                                                        ? controller.getTitle(index, itemIndex)
                                                                        : controller.selectedIndex[0] == index &&
                                                                                controller.selectedIndex[1] == itemIndex
                                                                            ? controller.getTitle(index, itemIndex,
                                                                                local: "it")
                                                                            : controller.getTitle(index, itemIndex),
                                                                    style: black17w400,
                                                                  ),
                                                                  if (data.ingredienti?.isNotEmpty ?? false)
                                                                    Text(
                                                                      controller.selectedIndex.isEmpty
                                                                          ? controller.getSubTitle(index, itemIndex)
                                                                          : controller.selectedIndex[0] == index &&
                                                                                  controller.selectedIndex[1] ==
                                                                                      itemIndex
                                                                              ? controller.getSubTitle(index, itemIndex,
                                                                                  local: "it")
                                                                              : controller.getSubTitle(
                                                                                  index, itemIndex),
                                                                      style: grey17w400,
                                                                      overflow: TextOverflow.clip,
                                                                    ),
                                                                  data.imageAVAL != null
                                                                      ? controller.selectedIndex.isEmpty
                                                                          // ? price(controller, data)
                                                                          ? Column(
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.end,
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
                                                                            )
                                                                          : controller.selectedIndex[0] == index &&
                                                                                  controller.selectedIndex[1] ==
                                                                                      itemIndex
                                                                              ? const SizedBox()
                                                                              // : price(controller, data)
                                                                              : Column(
                                                                                  crossAxisAlignment:
                                                                                      CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    if (data.priceD?.isNotEmpty ??
                                                                                        false)
                                                                                      Text(
                                                                                        "€ ${data.priceD}",
                                                                                        style: black17w400,
                                                                                      ),
                                                                                    if (data.priceM?.isNotEmpty ??
                                                                                        false)
                                                                                      Text(
                                                                                        "€ ${data.priceM}",
                                                                                        style: black17w400,
                                                                                      )
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
                                                                  ),
                                                                  // child: price(controller, data),
                                                                )
                                                              : controller.selectedIndex.isEmpty
                                                                  ? cachedNetworkImage(
                                                                      url: data.imageAVAL ?? "",
                                                                      height: 08.h,
                                                                      width: 12.h,
                                                                      name: '',
                                                                    )
                                                                  : (controller.selectedIndex[0] == index &&
                                                                          controller.selectedIndex[1] == itemIndex)
                                                                      ? Expanded(
                                                                          flex: 4,
                                                                          child: Column(
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
                                                                          ),
                                                                          // child: price(controller, data),
                                                                        )
                                                                      : (data.imageAVAL != null)
                                                                          ? cachedNetworkImage(
                                                                              url: data.imageAVAL ?? "",
                                                                              height: 08.h,
                                                                              width: 12.h,
                                                                              name: '')
                                                                          : Expanded(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                crossAxisAlignment:
                                                                                    CrossAxisAlignment.end,
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
                                                                              ),
                                                                              // child: price(controller, data),
                                                                            ),
                                                        ],
                                                      ),
                                                      if (controller.selectedIndex.isNotEmpty &&
                                                          controller.allergyImageList.isNotEmpty)
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
                                                  color: appDividerColor,
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
                          ),
                        );
                      },
                    ))
                ],
              );
      },
    );
  }

  PopupMenuButton<String> price(MenuPageController controller, ItemDataModel data) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: appGreyColor2.withOpacity(0.90),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      AppString.toGliAllErgEne,
                      style: grey10w400,
                    ),
                  ),
                  const Divider(color: appDividerColor),
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
                                    Text(
                                      country,
                                      style: white14w400,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (index != controller.countryRs.length - 1) const Divider(color: appDividerColor),
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
      child: Column(
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
      ),
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
          color: appDarkGreyColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
                color: appLightGreyColor,
                size: 20,
              ),
            ),
            Expanded(
              child: controller.isTapped
                  ? TextField(
                      cursorColor: appGreyColor2,
                      controller: controller.textController,
                      onChanged: controller.updateSearchText,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.symmetric(horizontal: 3),
                      ),
                      style: white14w400,
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
                        color: appGreyColor2,
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
        color: appDarkGreyColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.more_horiz,
          color: appLightGreyColor,
        ),
        color: appGreyColor2.withOpacity(0.90),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppString.toGliAllErgEne,
                        style: grey10w400,
                      ),
                    ),
                    const Divider(color: appDividerColor),
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
                                        Text(
                                          itemName,
                                          style: controller.selectedItems.contains(itemName)
                                              ? white14w400.copyWith(color: appRedColor)
                                              : white14w400,
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                            color: appWhiteColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (index != controller.popPopName.length - 1) const Divider(color: appDividerColor),
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
