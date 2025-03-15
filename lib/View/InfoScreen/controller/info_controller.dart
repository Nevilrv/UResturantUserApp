import 'dart:convert';
import 'dart:developer';
import 'dart:math' as m;

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:urestaurants_user/Constant/app_color.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/info_screen_config.dart';
import 'package:urestaurants_user/Utils/extention.dart';
import 'package:urestaurants_user/Utils/sql_helper.dart';
import 'package:urestaurants_user/View/HomeScreen/controller/home_screen_controller.dart';
import 'package:urestaurants_user/View/InfoScreen/Model/info_data_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';

class InfoController extends GetxController {
  Color iconColor = AppColor.appBlueColor;
  bool isContainerExpanded = false;
  bool fetchDataLoader = false;
  AppleMapController? appleMapController;
  bool addressValue = false;
  String? fullAddress;
  String? iframeHtml;
  InfoDataModel? infoDataModel;

  List time = [];
  final CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();
  String? url;
  List<double>? coordinates;
  String platform = 'Unknown';
  final Set<googlemap.Marker> markers = {};
  googlemap.GoogleMapController? mapController;
  bool googleSignLoader = false;
  bool mapOnTap = true;
  List<Map<String, dynamic>> days = [];

  @override
  void onInit() {
    super.onInit();
  }

  updateMapOnTap(bool val) {
    mapOnTap = val;
    update();
  }

  Future<void> initOrder({bool? isDbSame = false}) async {
    await fetchInfoData();
    if (mapController == null) {
      mapController?.animateCamera(
        googlemap.CameraUpdate.newCameraPosition(
          googlemap.CameraPosition(target: googlemap.LatLng(coordinates![0], coordinates![1]), zoom: 15),
        ),
      );
      await getMarkers();
    }
    update();
  }

  Future<void> fetchInfoData() async {
    fetchDataLoader = true;
    update();
    String? selectedRestaurantId = Get.find<HomeScreenController>().selectedRestaurant?.id;
    ;
    List<Map<String, dynamic>> restaurantData =
        await DatabaseHelper().getDataFromTable(tableName: DatabaseHelper.restaurant, where: "id", id: selectedRestaurantId ?? "");
    if (restaurantData.isNotEmpty) {
      try {
        infoDataModel = Get.find<HomeScreenController>().selectedRestaurant?.info;
        time.add(infoDataModel?.the001Monday);
        time.add(infoDataModel?.the002Tuesday);
        time.add(infoDataModel?.the003Wednesday);
        time.add(infoDataModel?.the004Thursday);
        time.add(infoDataModel?.the005Friday);
        time.add(infoDataModel?.the006Saturday);
        time.add(infoDataModel?.the007Sunday);
        platform = 'android';
        if (platform == 'Android') url = infoDataModel?.urlGMaps;
        if (platform == 'IOS') url = infoDataModel?.urlMaps;
        coordinates = [double.tryParse(restaurantData.first['lat']) ?? 0.0, double.tryParse(restaurantData.first['lang']) ?? 0.0];
        fullAddress = restaurantData.first['fulladdress'] ?? "";
        await getDateList();
      } catch (e) {
        debugPrint('e==========>>>>>$e');
      }
    }

    fetchDataLoader = false;
    update();
  }

  List dayList = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato", "Domenica"];

  getDateList() async {
    var data = Get.find<HomeScreenController>().selectedRestaurant?.exceptions;
    Map<String, dynamic>? tempData;
    if (data != null) {
      tempData = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
    }
    days = [];
    final now = DateTime.now().toUtc().add(const Duration(hours: 1));
    final currentDayIndex = now.weekday - 1;
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final dayIndex = (currentDayIndex + i) % 7;
      days.add({
        "date": formattedDate,
        "day": "${dayList[dayIndex]}",
        "time": time[dayIndex],
        "color": Colors.black,
        "color1": Colors.black,
      });
    }

    for (var ele1 in days) {
      if (tempData != null) {
        tempData.forEach(
          (key, value) {
            if (ele1["date"] == key) {
              if (value.toString().contains("orario")) {
                ele1["time"] = value["orario"];
                if (value["rename"] != null) {
                  ele1["day"] = value["rename"];
                }

                ele1["color"] = Colors.red;
                ele1["color1"] = Colors.red;
              } else {
                ele1["time"] = value;
                ele1["color"] = Colors.red;
              }
            }
          },
        );
      }
    }
  }

  Future<void> getMarkers() async {
    markers.clear();
    markers.add(
      googlemap.Marker(
        markerId: googlemap.MarkerId("${coordinates![0]}+${coordinates![1]}"),
        position: googlemap.LatLng(coordinates![0], coordinates![1]),
        onTap: () {
          if (platform == 'IOS') {
            launchMap(infoDataModel?.urlMaps ?? "");
          } else {
            launchMap(infoDataModel?.urlGMaps ?? "");
          }
        },
      ),
    );

    update();
  }

  Future<List<double>?> extractCoordinates(String url) async {
    try {
      Uri uri = Uri.parse(url);
      String? latLong = uri.queryParameters['ll'];
      if (latLong != null) {
        List<String> parts = latLong.split(',');
        if (parts.length == 2) {
          double latitude = double.parse(parts[0]);
          double longitude = double.parse(parts[1]);

          return [latitude, longitude];
        } else {
          debugPrint('Invalid lat-long format in the URL.');
        }
      } else {
        debugPrint('No lat-long (ll) parameter found in the URL.');
      }
    } catch (e) {
      debugPrint('Error parsing URL: $e');
    }
    return null;
  }

  void getGoogleMapController(googlemap.GoogleMapController googleMapController) {
    mapController = googleMapController;
    update();
    m.Random().nextInt(67);
  }

  Future<String?> getAddressFromCoordinates(String url) async {
    try {
      addressValue = true;
      update();
      Uri uri = Uri.parse(url);
      String? address = uri.queryParameters['address'];
      if (address != null && address.isNotEmpty) {
        String decodedAddress = Uri.decodeComponent(address);
        addressValue = false;
        update();
        return decodedAddress;
      } else {
        debugPrint('No address found in the URL.');
        addressValue = false;
        update();
        return null;
      }
    } catch (e) {
      addressValue = false;
      update();
      debugPrint('Error parsing the URL: $e');
      return null;
    }
  }

  Future<void> launchMap(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch ${Uri.parse(url)}');
    }
  }

  Future<void> launchPhoneDialer(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(Uri.parse(url.toString()))) {
      await launchUrl(Uri.parse(url.toString()));
    } else {
      throw 'Could not launch $url';
    }
  }

  bool isOpenOrNot() {
    TimeOfDay parseTimeOfDay(String time) {
      final parts = time.split(':').map((part) => int.parse(part.trim())).toList();
      return TimeOfDay(hour: parts[0], minute: parts[1]);
    }

    final now = DateTime.now();

    final timeRange = days[0]["time"];
    final ranges = timeRange.split('|').map((range) => range.trim()).toList();
    bool isOpen = false;
    for (var range in ranges) {
      final times = range.split('-').map((time) => time.trim()).toList();
      if (times.length == 2) {
        final startTime = parseTimeOfDay(times[0]);
        final endTime = parseTimeOfDay(times[1]);
        final startDateTime = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
        final endDateTime = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
        final currentDateTime = DateTime.now();

        if (endDateTime.isBefore(startDateTime)) {
          if (currentDateTime.isAfter(startDateTime) || currentDateTime.isBefore(endDateTime)) {
            isOpen = true;
          }
        } else if (currentDateTime.isAfter(startDateTime) && currentDateTime.isBefore(endDateTime)) {
          isOpen = true;
        }
      }
    }
    return isOpen;
  }

  void toggleContainerState() {
    isContainerExpanded = !isContainerExpanded;
    update();
  }

  Future<void> googleSignIn({required BuildContext context}) async {
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
        final userData = await InfoConfig().getUserData(id: user.uid);

        final List<String> nameParts = (user.displayName ?? "").split(" ");
        final String name = nameParts.isNotEmpty ? nameParts.first : "";
        final String surname = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
        if (userData == null) {
          Map<String, dynamic> body = {"Nome": name, "Cognome": surname, "Email": user.email};

          await InfoConfig().addUserData(id: user.uid, body: body);
        }
        preferences.putBool(SharedPreference.isLogin, true);
        preferences.putString(SharedPreference.userId, user.uid);
        preferences.putString(SharedPreference.userEmail, user.email ?? "");
        preferences.putString(SharedPreference.userFirstName, name);
        preferences.putString(SharedPreference.userLastName, surname);
        Navigator.pop(context);
      } else {
        debugPrint('Google Sign-In Failed');
      }
    } catch (e) {
      debugPrint('Error during Google Sign-In: $e');
    }
    googleSignLoader = false;
    update();
  }

  checkWifiStatus() async {
    bool isWiFiEnabled = await WiFiForIoTPlugin.isEnabled();
    if (isWiFiEnabled) {
      print("Wi-Fi is enabled");
    } else {
      // Optionally enable Wi-Fi if needed
      await WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: true);
    }
  }

  bool get isShowWifi => infoDataModel?.ssid != null && infoDataModel?.password != null;
  checkWifi() async {
    await checkWifiStatus();
    bool isConnected = await WiFiForIoTPlugin.connect(
      infoDataModel?.ssid ?? "",
      password: infoDataModel?.password,
      security: NetworkSecurity.WPA,
    );

    if (isConnected) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: "Success".primaryRegular(),
          backgroundColor: AppColor.appColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: "Not Connected".primaryRegular(),
          backgroundColor: AppColor.appColor,
        ),
      );
    }
    log('isConnected::::::::::::::::${isConnected}');
  }

  deleteUserAccount() async {
    String userId = preferences.getString(SharedPreference.userId) ?? "";
    await FirebaseAuth.instance.currentUser?.delete();
    preferences.logOut();
    Get.back();
    await InfoConfig().deleteUserData(id: userId);
  }

  /// SCROLL ANIMATION
  bool isShowAppBarText = false;

  ScrollController scrollController = ScrollController();

  initScrollListener() {
    scrollController.addListener(
      () {
        if (scrollController.offset > 42) {
          isShowAppBarText = true;
        } else {
          isShowAppBarText = false;
        }
        update();
      },
    );
  }
}
