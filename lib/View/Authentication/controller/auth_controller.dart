// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:urestaurants_user/View/Authentication/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:urestaurants/Constant/shared_pref.dart';
// import 'package:urestaurants/FirebaseConfig/auth_config.dart';
// import 'package:urestaurants/FirebaseConfig/menu_screen_config.dart';
// import 'package:urestaurants/Utils/app_routes.dart';
// import 'package:urestaurants/View/Authentication/models/user_model.dart';
//
// class AuthController extends GetxController {
//   /// Login Screen Variable
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool signingLoading = false;
//   Future signIn(BuildContext context) async {
//     try {
//       signingLoading = true;
//       update();
//       String email = emailController.text.trim();
//       String password = passwordController.text.trim();
//       log('email::::::::::::::::${email}');
//       UserCredential user = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       log('user::::::::::::::::${user.user?.email}');
//       Object? data = await AuthConfig().userData(user.user?.uid);
//
//       if (data != null) {
//         UserResponseModel userResponseModel = UserResponseModel.fromJson(json.decode(jsonEncode(data)));
//         await getMenuData(userResponseModel.place);
//         signingLoading = false;
//         update();
//
//         preferences.putBool(SharedPreference.isLogin, true);
//         preferences.putString(SharedPreference.userId, user.user?.uid.toString() ?? "");
//
//         Get.offAllNamed(Routes.bottomBar);
//       }
//
//       log('data::::::::::::::::${data}');
//       // Get.snackbar("Success", 'Sign-In Successful!');
//     } catch (e) {
//       signingLoading = false;
//       update();
//       log('e::::::::::::::::${e}');
//       String errorMessage = 'An error occurred. Please try again later.';
//
//       if (e is FirebaseAuthException) {
//         switch (e.code) {
//           case 'user-not-found':
//             errorMessage = 'No user found for that email.';
//             break;
//           case 'wrong-password':
//             errorMessage = 'Incorrect password.';
//             break;
//           case 'invalid-email':
//             errorMessage = 'Invalid email format.';
//             break;
//           default:
//             errorMessage = 'An unexpected error occurred.';
//         }
//       }
//
//       // Show error Snackbar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(errorMessage)),
//       );
//     }
//   }
//
//   Future<List<bool>> getMenuData(String id) async {
//     List<bool> temp = [false, false];
//     log('id::::::::::::::::${id}');
//     await preferences.putString(SharedPreference.id, id);
//     await MenuConfig(onPageFoundChanged: (bool found) {
//       temp.first = found;
//     }).sectionData();
//     // await infoController.fetchInfoData();
//     return temp;
//   }
// }
