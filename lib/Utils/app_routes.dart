import 'package:get/get.dart';
import 'package:urestaurants_user/View/BottomBar/bottom_bar_screen.dart';
import 'package:urestaurants_user/View/ProfileScreen/profile_screen.dart';

class Routes {
  static String bottomBar = "/bottomBar";

  static String newOrderScreen = "/newOrderScreen";

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
      name: profileScreen,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
