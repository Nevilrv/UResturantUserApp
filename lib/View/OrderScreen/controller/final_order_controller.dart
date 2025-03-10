import 'package:get/get.dart';
import 'package:urestaurants_user/View/OrderScreen/controller/new_order_screen_controller.dart';

class FinalOrderController extends GetxController {
  List<BuyItem> buyItem = Get.arguments;

  double totalPrice = 0.0;
  @override
  void onInit() {
    super.onInit();

    for (var element in buyItem) {
      if (element.amount.isNotEmpty) {
        double amount = double.tryParse(element.amount) ?? 0;
        totalPrice += amount;
      }

      element.subItem.forEach(
        (element2) {
          if (element2.amount.isNotEmpty) {
            double amount = double.tryParse(element2.amount) ?? 0;
            totalPrice += amount;
          }
        },
      );
    }
  }
}
