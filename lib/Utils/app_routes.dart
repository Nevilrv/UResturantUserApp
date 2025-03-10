import 'package:get/get.dart';
import 'package:urestaurants_user/View/BottomBar/bottom_bar_screen.dart';
import 'package:urestaurants_user/View/LoginScreen/login_screen.dart';
import 'package:urestaurants_user/View/OrderScreen/confirm_order_screen.dart';
import 'package:urestaurants_user/View/OrderScreen/final_order_screen.dart';

class Routes {
  static String bottomBar = "/bottomBar";

  static String newOrderScreen = "/newOrderScreen";
  static String loginScreen = "/loginScreen";
  static String profileScreen = "/profileScreen";
  static String finalOrderScreen = "/finalOrderScreen";
  static String confirmOrderScreen = "/confirmOrderScreen";

  static List<GetPage> routes = [
    // GetPage(
    //   name: authOptionScreen,
    //   page: () => AuthOptionScreen(),
    //   transition: Transition.fadeIn,
    // ),
    GetPage(
      name: bottomBar,
      page: () => const BottomBar(pageFound: true, isReservation: false),
      transition: Transition.fadeIn,
    ),

    // GetPage(
    //   name: newOrderScreen,
    //   page: () => const NewOrderScreen(),
    //   transition: Transition.rightToLeft,
    // ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    // GetPage(
    //   name: profileScreen,
    //   page: () => const ProfileScreen(),
    //   transition: Transition.rightToLeft,
    // ),
    GetPage(
      name: finalOrderScreen,
      page: () => const FinalOrderScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: confirmOrderScreen,
      page: () => const ConfirmOrderScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
