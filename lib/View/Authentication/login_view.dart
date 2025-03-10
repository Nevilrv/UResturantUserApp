// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
// import 'package:urestaurants/Constant/app_string.dart';
// import 'package:urestaurants/Utils/app_sizebox.dart';
// import 'package:urestaurants/Utils/extention.dart';
// import 'package:urestaurants/View/Authentication/controller/auth_controller.dart';
// import 'package:urestaurants/Widgets/app_text_form_field.dart';
//
// import '../../Constant/app_color.dart';
// import '../../Widgets/app_material_button.dart';
//
// class LoginView extends StatelessWidget {
//   LoginView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AuthController>(builder: (controller) {
//       return Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Container(
//           height: 50.h,
//           width: 100.w,
//           margin: EdgeInsets.symmetric(horizontal: 5.w),
//           decoration: BoxDecoration(color: AppColor.appOffWhiteColor, borderRadius: BorderRadius.circular(20)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               5.h.addHSpace(),
//               AppString.login.primaryBold(fontColor: AppColor.appBlack1Color, fontSize: 23.sp, fontWeight: FontWeight.w600),
//               2.h.addHSpace(),
//               Container(
//                 height: 11.h,
//                 width: double.infinity,
//                 decoration: BoxDecoration(color: AppColor.appWhiteColor, borderRadius: BorderRadius.circular(10)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     AppTextFormField(
//                       controller: controller.emailController,
//                       isDense: true,
//                       hintText: AppString.email,
//                     ),
//                     AppTextFormField(
//                       controller: controller.passwordController,
//                       isDense: true,
//                       obscureText: true,
//                       hintText: AppString.password,
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 child: AppString.resetPassword.primaryRegular(fontSize: 11, fontColor: AppColor.appBlueColor, fontWeight: FontWeight.w400),
//               ).paddingOnly(left: 2.w, top: 0.8.h),
//               3.h.addHSpace(),
//               controller.signingLoading
//                   ? const Center(
//                       child: CircularProgressIndicator(
//                       color: AppColor.appColor,
//                     ))
//                   : AppMaterialButton(
//                       btnColor: AppColor.appWhiteColor,
//                       isShaddow: false,
//                       text: AppString.continueStr,
//                       textColor: AppColor.appBlueColor,
//                       fontSize: 16,
//                       onPressed: () async {
//                         await controller.signIn(context);
//                       },
//                     )
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
