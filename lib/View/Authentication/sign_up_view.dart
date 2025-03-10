// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:urestaurants/Constant/app_color.dart';
// import 'package:urestaurants/Constant/app_string.dart';
// import 'package:urestaurants/Utils/app_sizebox.dart';
// import 'package:urestaurants/Utils/extention.dart';
// import 'package:urestaurants/Widgets/app_material_button.dart';
// import 'package:urestaurants/Widgets/app_text_form_field.dart';
//
// class SignUpView extends StatelessWidget {
//   const SignUpView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//       child: Container(
//         height: 60.h,
//         width: 100.w,
//         margin: EdgeInsets.symmetric(horizontal: 5.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             5.h.addHSpace(),
//             AppString.register.primaryBold(fontColor: AppColor.appBlack1Color, fontSize: 23.sp, fontWeight: FontWeight.w600),
//             2.h.addHSpace(),
//             Container(
//               // height: 11.h,
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(color: AppColor.appWhiteColor, borderRadius: BorderRadius.circular(10)),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   AppTextFormField(
//                     hintText: "Nome",
//                     isDense: true,
//                     paddingTop: 0.5.h,
//                     paddingBottom: 0.7.h,
//                   ),
//                   AppTextFormField(
//                     hintText: "Congnome",
//                     isDense: true,
//                     paddingBottom: 0.7.h,
//                   ),
//                   AppTextFormField(
//                     hintText: "Cellulare",
//                     isDense: true,
//                     paddingBottom: 0.7.h,
//                   ),
//                   AppTextFormField(
//                     hintText: "Email",
//                     isDense: true,
//                     paddingBottom: 0.7.h,
//                   ),
//                   AppTextFormField(
//                     hintText: "Password",
//                     isDense: true,
//                     obscureText: true,
//                     paddingBottom: 0.7.h,
//                   ),
//                   AppTextFormField(
//                     hintText: "Ripeti Password",
//                     isDense: true,
//                     obscureText: true,
//                     paddingBottom: 0.7.h,
//                   ),
//                 ],
//               ),
//             ),
//             3.h.addHSpace(),
//             const AppMaterialButton(
//               btnColor: AppColor.appWhiteColor,
//               isShaddow: false,
//               text: AppString.continueStr,
//               textColor: AppColor.appBlueColor,
//               fontSize: 16,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
