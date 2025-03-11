import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/Utils/app_routes.dart';
import 'package:urestaurants_user/Utils/status_bar_color.dart';
import 'package:urestaurants_user/View/InfoScreen/controller/info_controller.dart';

InfoController infoController = Get.put(InfoController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.android,
        );
  }

  StatusBarColorChange.defaultColor();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (p0, p1, p2) {
        return GetMaterialApp(
          title: 'AI Tarcentino',
          theme: ThemeData(
            primaryColor: AppColor.appGreyColor,
            useMaterial3: true,
            scaffoldBackgroundColor: CupertinoColors.systemGrey6,
            appBarTheme: const AppBarTheme(color: Colors.transparent, foregroundColor: Colors.transparent),
          ),
          debugShowCheckedModeBanner: false,
          getPages: Routes.routes,
          initialRoute: Routes.bottomBar,
        );
      },
    );
  }
}
