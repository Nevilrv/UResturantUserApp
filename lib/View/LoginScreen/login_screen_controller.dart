import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/info_screen_config.dart';
import 'package:urestaurants_user/Utils/app_routes.dart';

class LoginScreenController extends GetxController {
  bool googleSignLoader = false;

  Future<void> googleSignIn({required BuildContext context}) async {
    await GoogleSignIn().signOut();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    try {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      googleSignLoader = true;
      update();

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;
      if (user != null) {
        log('user.uid::::::::::::::::${user.uid}');
        final userData = await InfoConfig().getUserData(id: user.uid);
        log('userData::::::::::::::::${userData}');
        final List<String> nameParts = (user.displayName ?? "").split(" ");
        final String name = nameParts.isNotEmpty ? nameParts.first : "";
        final String surname = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
        if (userData == null) {
          Map<String, dynamic> body = {"Nome": name, "Cognome": surname, "Email": user.email};
          log('body::::::::::::::::${body}');
          await InfoConfig().addUserData(id: user.uid, body: body);
        }
        preferences.putBool(SharedPreference.isLogin, true);
        preferences.putString(SharedPreference.userId, user.uid);
        preferences.putString(SharedPreference.userEmail, user.email ?? "");
        preferences.putString(SharedPreference.userFirstName, name);
        preferences.putString(SharedPreference.userLastName, surname);
        Get.offAllNamed(Routes.bottomBar);
      } else {
        debugPrint('Google Sign-In Failed');
      }
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
    }
    googleSignLoader = false;
    update();
  }
}
