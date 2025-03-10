import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/menu_screen_config.dart';
import 'package:urestaurants_user/FirebaseConfig/reservation_config.dart';

import 'View/Bottombar/bottombar.dart';

Future<List<bool>> onAppInit() async {
  List<bool> temp = [false, false];

  String id = preferences.getString(SharedPreference.id) ?? "";

  if (id.isNotEmpty && id != (Uri.base.pathSegments.isEmpty ? "01" : Uri.base.pathSegments.last)) {
    await preferences.putString(SharedPreference.currentPage, "menu");
  }

  await preferences.putString(SharedPreference.id, Uri.base.pathSegments.isEmpty ? "01" : Uri.base.pathSegments.last);
  await MenuConfig(onPageFoundChanged: (bool found) {
    temp.first = found;
  }).sectionData();
  await ReservationConfig(isActive: (bool found) {
    temp.last = found;
  }).getReservationStatus();

  return temp;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBYLi9lWPXZGRT6uYuW813v2Mxt-NJ9FoM",
      authDomain: "urestaurants-ebb27.firebaseapp.com",
      databaseURL: "https://urestaurants-ebb27-default-rtdb.europe-west1.firebasedatabase.app",
      projectId: "urestaurants-ebb27",
      storageBucket: "urestaurants-ebb27.appspot.com",
      messagingSenderId: "820988340688",
      appId: "1:820988340688:web:7fdb768bcc2006ffcfb1d5",
      measurementId: "G-6LWCGSDE38",
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: appGreyColor,
      systemNavigationBarColor: appGreyColor,
      systemNavigationBarDividerColor: appGreyColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool val = true;
  List<bool> valList = [];

  onInit() async {
    try {
      valList = await onAppInit();
    } catch (e) {
      debugPrint('e==========>>>>>$e');
    }
    val = false;
    setState(() {});
  }

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.invertedStylus,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown,
              PointerDeviceKind.trackpad
            },
          ),
          title: 'URestaurants',
          theme: ThemeData(
            primaryColor: appGreyColor,
            useMaterial3: true,
          ),
          home: val
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/app_logo.png",
                        height: 100,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                        width: 60,
                        height: 2,
                        child: Center(
                          child: LinearProgressIndicator(
                            backgroundColor: appBlueColor,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : BottomBar(pageFound: valList.first, isReservation: valList.last),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
