// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// class AuthOptionScreen extends StatelessWidget {
//   AuthOptionScreen({super.key});
//   AuthController authController = Get.put(AuthController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CupertinoColors.systemGrey6,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 15.w),
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 25.h,
//               ),
//               const Text(
//                 "URestaurants",
//                 style: AppTextStyle.black35w600,
//               ),
//               const Text(
//                 "For Business",
//                 style: AppTextStyle.black22w300,
//               ),
//               SizedBox(
//                 height: 25.h,
//               ),
//               AppMaterialButton(
//                 text: AppString.login,
//                 onPressed: () {
//                   StatusBarColorChange.bottomBarColor();
//                   showModalBottomSheet(
//                     context: context,
//                     useSafeArea: true,
//                     isScrollControlled: true,
//                     backgroundColor: AppColor.appOffWhiteColor,
//                     builder: (context) {
//                       return LoginView();
//                     },
//                   ).whenComplete(
//                     () {
//                       StatusBarColorChange.defaultColor();
//                     },
//                   );
//                   // Get.toNamed(Routes.loginScreen);
//                 },
//               ),
//               SizedBox(
//                 height: 1.5.h,
//               ),
//               AppMaterialButton(
//                 text: AppString.register,
//                 onPressed: () {
//                   StatusBarColorChange.bottomBarColor();
//                   showModalBottomSheet(
//                     context: context,
//                     useSafeArea: true,
//                     isScrollControlled: true,
//                     backgroundColor: AppColor.appOffWhiteColor,
//                     builder: (context) {
//                       return const SignUpView();
//                     },
//                   ).whenComplete(
//                     () {
//                       StatusBarColorChange.defaultColor();
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
