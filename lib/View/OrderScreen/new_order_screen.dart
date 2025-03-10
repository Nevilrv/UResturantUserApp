import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/app_string.dart';
import 'package:urestaurants_user/Utils/app_loader.dart';
import 'package:urestaurants_user/Utils/app_routes.dart';
import 'package:urestaurants_user/Utils/app_sizebox.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/new_order_screen_controller.dart';
import 'package:urestaurants_user/View/OrderScreen/models/iteam_model.dart';
import 'package:urestaurants_user/View/OrderScreen/widget/ingredient_bottom_sheet.dart';
import 'package:urestaurants_user/View/OrderScreen/widget/iteam_type_widget.dart';
import 'package:urestaurants_user/View/OrderScreen/widget/maxi_dialog.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  NewOrderScreenController newOrderScreenController = Get.find();
  @override
  void initState() {
    newOrderScreenController.clearData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewOrderScreenController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          leadingWidth: 0,
          forceMaterialTransparency: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                  onTap: () {
                    HapticFeedBack.buttonClick();
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColor.appBlueColor,
                  )),
              const Spacer(),
              (controller.selectedIndex == 0
                      ? "Normali"
                      : controller.selectedIndex == 1
                          ? "Maxi"
                          : AppString.crackle)
                  .primarySemiBold(fontSize: 15, fontColor: AppColor.appBlackColor, letterSpacing: 0.8),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    if (controller.checkValidationForChangeItemType()) {
                      if (controller.buyItem.isEmpty) {
                        showDialog(context, title: "Attenzione", discription: "Inserirw almeno un elemento per procedere");
                      } else {
                        HapticFeedBack.buttonClick();
                        Get.toNamed(Routes.finalOrderScreen, arguments: controller.buyItem);
                      }
                    } else {
                      showPizzaCombinationDialog(context);
                    }
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.appBlueColor,
                  )),
            ],
          ).paddingSymmetric(horizontal: 10),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    controller.type.length,
                    (index) {
                      return index == 1
                          ? MaxiDialog()
                          : ItemTypeWidget(
                              onTap: () {
                                if (controller.checkValidationForChangeItemType()) {
                                  ItemType itemType = ItemType.normal;

                                  switch (index) {
                                    case 0:
                                      itemType = ItemType.normal;
                                      break;
                                    case 1:
                                      itemType = ItemType.maxi1;
                                      break;
                                    case 2:
                                      itemType = ItemType.scrocchiarelle;
                                      break;
                                    case 3:
                                      itemType = ItemType.contorni;
                                      break;
                                  }
                                  controller.updateSelectedType(type: itemType, index: index);
                                } else {
                                  showPizzaCombinationDialog(context);
                                }
                              },
                              selectedIndex: controller.selectedIndex,
                              title: controller.type[index],
                              index: index,
                            );
                    },
                  ),
                ),
              ),
              5.h.addHSpace(),
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 150),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: List.generate(
                          controller.buyItem.length,
                          (index) {
                            BuyItem item = controller.buyItem[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      "${item.qty} x ${item.name}".primaryRegular(fontColor: AppColor.appBlackColor),
                                      const Spacer(),
                                      "${item.subItem.any(
                                        (element) => element.isMainItem == true,
                                      ) ? "" : "€"} ${item.amount}"
                                          .primaryRegular(fontColor: AppColor.appBlackColor),
                                      2.w.addWSpace(),
                                      GestureDetector(
                                        onTap: () {
                                          HapticFeedBack.buttonClick();
                                          controller.removeItem(index);
                                        },
                                        child: const Icon(
                                          CupertinoIcons.clear_circled,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                  if (item.subItem.isNotEmpty)
                                    Column(
                                      children: List.generate(
                                        item.subItem.length,
                                        (subItemIndex) {
                                          BuyItem subItem = item.subItem[subItemIndex];
                                          return Row(
                                            children: [
                                              "${subItem.isMainItem ? "${subItem.qty} x" : subItem.itemType == ItemType.subtractedVariants ? "-" : "+"} ${subItem.name}"
                                                  .primaryRegular(
                                                fontColor: AppColor.appBlackColor,
                                              ),
                                              const Spacer(),
                                              (subItem.itemType == ItemType.subtractedVariants ? "" : "€ ${subItem.amount}").primaryRegular(
                                                fontColor: AppColor.appBlackColor,
                                              ),
                                              2.w.addWSpace(),
                                              !subItem.isMainItem
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        HapticFeedBack.buttonClick();
                                                        controller.removeSubItem(index, subItemIndex);
                                                      },
                                                      child: const Icon(
                                                        CupertinoIcons.clear_circled,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      width: 15,
                                                    )
                                            ],
                                          ).paddingOnly(left: 15, top: 5);
                                        },
                                      ),
                                    )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              5.h.addHSpace(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: List.generate(
                        controller.items.length,
                        (index) {
                          return GestureDetector(
                            onTap: () async {
                              HapticFeedBack.buttonClick();
                              controller.updateSelectedItemIndex(index);
                              String price = " 0";
                              ItemModel item = controller.items[index];
                              String qty = "1";
                              if (controller.buyItem.isEmpty) {
                                if (controller.selectedIndex == 0) {
                                  price = item.priceD;
                                  qty = "1";
                                  controller.addItem(
                                    BuyItem(
                                        name: item.name,
                                        qty: qty,
                                        amount: price,
                                        subItem: [],
                                        itemType: ItemType.normal,
                                        cod: item.cod,
                                        isMainItem: true),
                                  );
                                } else if (controller.selectedIndex == 1) {
                                  if (controller.selectedItemType == ItemType.maxi1) {
                                    price = item.priceM;
                                    qty = "1";
                                    controller.addItem(BuyItem(
                                        name: item.name,
                                        qty: qty,
                                        amount: price,
                                        subItem: [],
                                        itemType: ItemType.maxi1,
                                        cod: item.codMaxi,
                                        isMainItem: true));
                                  } else if (controller.selectedItemType == ItemType.maxi2) {
                                    double priceM = double.tryParse(item.priceM) ?? 0.0;
                                    price = ((priceM / 2) * 1.1).toStringAsFixed(2);
                                    controller.addItem(BuyItem(
                                        name: "Combo Maxi 2",
                                        qty: "1",
                                        amount: "",
                                        itemType: ItemType.maxi2,
                                        cod: "",
                                        isMainItem: true,
                                        subItem: [
                                          BuyItem(
                                            cod: item.codMaxi,
                                            subItem: [],
                                            name: item.name,
                                            amount: price,
                                            isMainItem: true,
                                            qty: "1/2",
                                            itemType: ItemType.pizza,
                                          )
                                        ]));
                                  } else if (controller.selectedItemType == ItemType.maxi3) {
                                    double priceM = double.tryParse(item.priceM) ?? 0.0;
                                    price = ((priceM / 3) * 1.1).toStringAsFixed(2);
                                    controller.addItem(BuyItem(
                                        name: "Combo Maxi 3",
                                        qty: "1",
                                        amount: "",
                                        itemType: ItemType.maxi3,
                                        cod: "",
                                        isMainItem: true,
                                        subItem: [
                                          BuyItem(
                                            subItem: [],
                                            name: item.name,
                                            amount: price,
                                            isMainItem: true,
                                            qty: "1/3",
                                            itemType: ItemType.pizza,
                                            cod: item.codMaxi,
                                          )
                                        ]));
                                  } else if (controller.selectedItemType == ItemType.maxi4) {
                                    double priceM = double.tryParse(item.priceM) ?? 0.0;
                                    price = ((priceM / 4) * 1.1).toStringAsFixed(2);
                                    controller.addItem(BuyItem(
                                      name: "Combo Maxi 4",
                                      qty: "1",
                                      amount: "",
                                      itemType: ItemType.maxi4,
                                      isMainItem: true,
                                      cod: "",
                                      subItem: [
                                        BuyItem(
                                            name: item.name,
                                            amount: price,
                                            isMainItem: true,
                                            qty: "1/4",
                                            cod: item.codMaxi,
                                            itemType: ItemType.pizza,
                                            subItem: []),
                                      ],
                                    ));
                                  }
                                } else if (controller.selectedIndex == 2) {
                                  double priceM = double.tryParse(item.priceM) ?? 0.0;
                                  price = ((priceM / 2) * 1.2).toStringAsFixed(2);
                                  controller.addItem(BuyItem(
                                      name: "Scrocchiarella",
                                      qty: "1",
                                      amount: "",
                                      itemType: ItemType.maxi2,
                                      subItem: [
                                        BuyItem(
                                            name: item.name,
                                            amount: price,
                                            isMainItem: true,
                                            qty: "1/2",
                                            cod: item.codMaxi,
                                            itemType: ItemType.pizza,
                                            subItem: [])
                                      ],
                                      isMainItem: true,
                                      cod: ""));
                                }
                              } else {
                                if (controller.buyItem.last.itemType == ItemType.maxi2 &&
                                    controller.buyItem.last.subItem
                                            .where(
                                              (element) => element.isMainItem == true,
                                            )
                                            .length <
                                        2) {
                                  double priceM = double.tryParse(item.priceM) ?? 0.0;
                                  price = ((priceM / 2) * 1.1).toStringAsFixed(2);
                                  controller.addIngredient(BuyItem(
                                      name: item.name,
                                      amount: price,
                                      qty: "1/2",
                                      isMainItem: true,
                                      subItem: [],
                                      itemType: ItemType.pizza,
                                      cod: item.codMaxi));
                                } else if (controller.buyItem.last.itemType == ItemType.maxi3 &&
                                    controller.buyItem.last.subItem
                                            .where(
                                              (element) => element.isMainItem == true,
                                            )
                                            .length <
                                        3) {
                                  double priceM = double.tryParse(item.priceM) ?? 0.0;
                                  price = ((priceM / 3) * 1.1).toStringAsFixed(2);
                                  controller.addIngredient(BuyItem(
                                      name: item.name,
                                      amount: price,
                                      qty: "1/3",
                                      isMainItem: true,
                                      subItem: [],
                                      itemType: ItemType.pizza,
                                      cod: item.codMaxi));
                                } else if (controller.buyItem.last.itemType == ItemType.maxi4 &&
                                    controller.buyItem.last.subItem
                                            .where(
                                              (element) => element.isMainItem == true,
                                            )
                                            .length <
                                        4) {
                                  double priceM = double.tryParse(item.priceM) ?? 0.0;
                                  price = ((priceM / 4) * 1.1).toStringAsFixed(2);
                                  controller.addIngredient(BuyItem(
                                      name: item.name,
                                      amount: price,
                                      qty: "1/4",
                                      isMainItem: true,
                                      subItem: [],
                                      itemType: ItemType.pizza,
                                      cod: item.codMaxi));
                                } else {
                                  if (controller.selectedIndex == 0) {
                                    price = item.priceD;
                                    qty = "1";
                                    controller.addItem(
                                      BuyItem(
                                          name: item.name,
                                          qty: qty,
                                          amount: price,
                                          subItem: [],
                                          itemType: ItemType.normal,
                                          cod: item.codMaxi,
                                          isMainItem: true),
                                    );
                                  } else if (controller.selectedIndex == 1) {
                                    if (controller.selectedItemType == ItemType.maxi1) {
                                      price = item.priceM;
                                      qty = "1";
                                      controller.addItem(BuyItem(
                                          name: "Maxi ${item.name}",
                                          qty: qty,
                                          amount: price,
                                          subItem: [],
                                          itemType: ItemType.maxi1,
                                          isMainItem: true,
                                          cod: item.codMaxi));
                                    } else if (controller.selectedItemType == ItemType.maxi2) {
                                      double priceM = double.tryParse(item.priceM) ?? 0.0;
                                      price = ((priceM / 2) * 1.1).toStringAsFixed(2);
                                      controller.addItem(BuyItem(
                                          name: "Combo Maxi 2",
                                          qty: "1",
                                          amount: "",
                                          itemType: ItemType.maxi2,
                                          cod: "",
                                          isMainItem: true,
                                          subItem: [
                                            BuyItem(
                                                name: item.name,
                                                amount: price,
                                                isMainItem: true,
                                                qty: "1/2",
                                                cod: item.codMaxi,
                                                itemType: ItemType.pizza,
                                                subItem: [])
                                          ]));
                                    } else if (controller.selectedItemType == ItemType.maxi3) {
                                      double priceM = double.tryParse(item.priceM) ?? 0.0;
                                      price = ((priceM / 3) * 1.1).toStringAsFixed(2);
                                      controller.addItem(
                                        BuyItem(
                                            name: "Combo Maxi 3",
                                            qty: "1",
                                            amount: "",
                                            itemType: ItemType.maxi3,
                                            isMainItem: true,
                                            cod: "",
                                            subItem: [
                                              BuyItem(
                                                  name: item.name,
                                                  amount: price,
                                                  isMainItem: true,
                                                  qty: "1/3",
                                                  subItem: [],
                                                  itemType: ItemType.pizza,
                                                  cod: item.codMaxi),
                                            ]),
                                      );
                                    } else if (controller.selectedItemType == ItemType.maxi4) {
                                      double priceM = double.tryParse(item.priceM) ?? 0.0;
                                      price = ((priceM / 4) * 1.1).toStringAsFixed(2);
                                      controller.addItem(BuyItem(
                                          name: "Combo Maxi 4",
                                          qty: "1",
                                          amount: "",
                                          itemType: ItemType.maxi4,
                                          cod: "",
                                          isMainItem: true,
                                          subItem: [
                                            BuyItem(
                                              name: item.name,
                                              amount: price,
                                              isMainItem: true,
                                              qty: "1/4",
                                              cod: item.codMaxi,
                                              itemType: ItemType.pizza,
                                              subItem: [],
                                            ),
                                          ]));
                                    }
                                  } else if (controller.selectedIndex == 2) {
                                    double priceM = double.tryParse(item.priceM) ?? 0.0;
                                    price = ((priceM / 2) * 1.2).toStringAsFixed(2);
                                    controller.addItem(
                                      BuyItem(
                                          name: "Scrocchiarella",
                                          qty: "1",
                                          amount: "",
                                          itemType: ItemType.maxi2,
                                          cod: "",
                                          isMainItem: true,
                                          subItem: [
                                            BuyItem(
                                              name: item.name,
                                              amount: price,
                                              isMainItem: true,
                                              qty: "1/2",
                                              subItem: [],
                                              itemType: ItemType.pizza,
                                              cod: item.codMaxi,
                                            ),
                                          ]),
                                    );
                                  }
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: controller.selectedItemIndex == index ? AppColor.appDividerColor : Colors.transparent,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(controller.selectedItemIndex == 0 ? 10 : 0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  if ((controller.selectedItemIndex == index))
                                    Builder(builder: (context) {
                                      return 1.h.addHSpace();
                                    }),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          controller.items[index].name.primaryMedium(fontColor: AppColor.appBlackColor, fontSize: 15),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            child: controller.items[index].ingredienti.primaryRegular(
                                              fontColor: AppColor.appGreyColor5,
                                              maxLine: 3,
                                              fontSize: 13,
                                              textOverflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) => IngredientBottomSheet(
                                              itemName: controller.items[index].name,
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          CupertinoIcons.pencil_ellipsis_rectangle,
                                          color: controller.selectedIndex == 0
                                              ? AppColor.appColor
                                              : controller.selectedIndex == 1
                                                  ? AppColor.appOrangeColor
                                                  : controller.selectedIndex == 2
                                                      ? AppColor.appRedColor
                                                      : Colors.yellow,
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(right: 15),
                                  Builder(builder: (context) {
                                    return 1.h.addHSpace();
                                  }),
                                  if (((controller.items.length - 1) != index) && (((controller.selectedItemIndex ?? 0) - 1) != index))
                                    const Divider(
                                      color: AppColor.appDividerColor,
                                      thickness: 0.7,
                                      height: 0,
                                    ),
                                  if (((controller.selectedItemIndex ?? 0) - 1) != index)
                                    Builder(builder: (context) {
                                      return 1.h.addHSpace();
                                    }),
                                ],
                              ).paddingOnly(left: 15),
                            ),
                          );
                        },
                      ),
                    ).paddingOnly(top: controller.selectedItemIndex == 0 ? 0 : 5, bottom: 10),
                  ),
                ),
              ),
              1.h.addHSpace(),
            ],
          ),
        ),
      );
    });
  }

  void showPizzaCombinationDialog(BuildContext context) {
    HapticFeedBack.onError();
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

  showDialog(BuildContext context, {String? title, String? discription}) {
    HapticFeedBack.onError();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(discription ?? ""),
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
}
