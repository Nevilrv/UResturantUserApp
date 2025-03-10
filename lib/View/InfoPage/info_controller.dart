import 'dart:convert';
import 'dart:math';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googlemap;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/FirebaseConfig/info_screen_config.dart';
import 'package:urestaurants_user/View/InfoPage/Model/info_data_model.dart';
import 'package:urestaurants_user/constant/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoController extends GetxController {
  Color iconColor = appBlueColor;
  bool isContainerExpanded = false;
  bool fetchDataLoader = false;
  AppleMapController? appleMapController;
  bool addressValue = false;
  String? fullAddress;
  String? iframeHtml;
  InfoDataModel? infoDataModel;
  String? id;
  List time = [];
  final CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();
  String? url;
  List<double>? coordinates;
  String platform = 'Unknown';
  final Set<googlemap.Marker> markers = {};
  googlemap.GoogleMapController? mapController;

  List<Map<String, dynamic>> days = [];

  @override
  void onInit() {
    id = preferences.getString(SharedPreference.id) ?? "01";
    super.onInit();
  }

  Future<void> initOrder() async {
    await fetchInfoData();

    if (mapController == null) {
      mapController?.animateCamera(
        googlemap.CameraUpdate.newCameraPosition(
          googlemap.CameraPosition(target: googlemap.LatLng(coordinates![0], coordinates![1]), zoom: 15),
        ),
      );
      await getMarkers();
    }
  }

  Future<void> fetchInfoData() async {
    if (infoDataModel != null) return;
    fetchDataLoader = true;
    update();
    try {
      final snapshot = await InfoConfig().infoData(id ?? '01');
      infoDataModel = InfoDataModel.fromJson(json.decode(jsonEncode(snapshot)));
      time.add(infoDataModel?.the001Monday);
      time.add(infoDataModel?.the002Tuesday);
      time.add(infoDataModel?.the003Wednesday);
      time.add(infoDataModel?.the004Thursday);
      time.add(infoDataModel?.the005Friday);
      time.add(infoDataModel?.the006Saturday);
      time.add(infoDataModel?.the007Sunday);
      url = infoDataModel?.urlGMaps;

      coordinates = await extractCoordinates("${infoDataModel?.urlMaps}");
      fullAddress = await getAddressFromCoordinates(infoDataModel?.urlMaps ?? "") ?? await getAddressFromCoordinatesFromPackage();

      await getDateList();
    } catch (e) {
      debugPrint('e==========>>>>>$e');
    }
    fetchDataLoader = false;
    update();
  }

  Future<Object?> getExceptionsData() async {
    final snapshot = await InfoConfig().exceptionsData(id ?? '01');
    return snapshot;
  }

  List dayList = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato", "Domenica"];

  getDateList() async {
    await fetchInfoData();
    var data = await getExceptionsData();
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
                ele1["day"] = value["rename"];
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
    Random().nextInt(67);
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

  Future<String> getAddressFromCoordinatesFromPackage() async {
    addressValue = true;
    update();
    GeoCode geoCode = GeoCode();

    Address address = await geoCode.reverseGeocoding(
      latitude: coordinates!.first,
      longitude: coordinates!.last,
    );
    if (address.toString().contains("Throttled")) {
      return getAddressFromCoordinatesFromPackage();
    }
    String formattedAddress =
        "${address.streetNumber ?? ""}${address.streetNumber == null ? "" : ", "}${address.streetAddress ?? ""}${address.streetAddress == null ? "" : ", "}${address.city ?? ""}${address.streetAddress == null && address.countryName != null ? "" : ", "}${address.countryName}";
    addressValue = false;
    update();
    return formattedAddress;
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

  bool googleSignLoader = false;
  Future<void> googleSignIn({required BuildContext context, required StateSetter setState}) async {
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
      setState(() {});
      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;
      if (user != null) {
        final userData = await InfoConfig().getUserData(id: user.uid);
        final List<String> nameParts = (user.displayName ?? "").split(" ");
        final String name = nameParts.isNotEmpty ? nameParts.first : "";
        final String surname = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
        if (userData == null) {
          Map<String, dynamic> body = {"Nome": name, "Cognome": surname, "Email": user.email, "Id": user.uid};
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
    setState(() {});
  }
}
