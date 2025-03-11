import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:urestaurants_user/FirebaseConfig/common_config.dart';
import 'package:urestaurants_user/Utils/cache_manager.dart';
import 'package:urestaurants_user/View/HomeScreen/model/all_data_model.dart';

class RestaurentConfig {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  CustomCacheManager customCacheManager = CustomCacheManager();

  Future<List<AllDataModel>> getData() async {
    DataSnapshot data = await _databaseRef.get();

    Map<String, dynamic> decodedData = jsonDecode(jsonEncode(data.value));

    decodedData.removeWhere(
      (key, value) {
        try {
          int? keyInt = int.parse(key);
          return false;
        } catch (error) {
          return true;
        }
      },
    );

    decodedData.removeWhere(
      (key, value) {
        if (value['Info'] != null) {
          if (value['Info']['isActive'] != null) {
            return value['Info']['isActive'] == false;
          }

          return false;
        }
        return true;
      },
    );
    List<AllDataModel> allDataModel = [];
    for (var entry in decodedData.entries) {
      var value = entry.value;
      var key = entry.key;
      if (value['Info'] != null) {
        try {
          if (value['Info']['logoUrl'] == null) {
            String? res = await CommonConfig().loadImage("ImagePlaces", key, "jpg");

            value['Info']['logoUrl'] = res;
          }
          customCacheManager.getSingleFile(value['Info']['logoUrl']);
        } catch (error) {}
      }
      allDataModel.add(AllDataModel.fromJson(value, key));
    }

    try {
      Map<String, String> imageUrls = {};
      for (int index = 0; index < allDataModel.length; index++) {
        List<double>? coordinates = await extractCoordinates("${allDataModel[index].info?.urlMaps}");

        if (coordinates != null && coordinates.length == 2) {
          allDataModel[index].lat = coordinates[0];
          allDataModel[index].long = coordinates[1];
        }
        allDataModel[index].fullAddress = await getAddressFromCoordinatesFromPackage(coordinates ?? [0.0, 0.0]);

        /// Section Image
        try {
          for (int i = 0; i < (allDataModel[index].config?.sections?.length ?? 0); i++) {
            if ((allDataModel[index].config?.sections?[i].imageUrl?.isEmpty ?? true)) {
              String name = allDataModel[index].config?.sections?[i].name ?? "";
              if (imageUrls.containsKey(name)) {
                allDataModel[index].config?.sections?[i].imageUrl = imageUrls[name];
              } else {
                String? res = await CommonConfig().loadImage("sectionImages", name, "jpeg");
                allDataModel[index].config?.sections?[i].imageUrl = res;

                imageUrls.addAll({name: res ?? ""});
                customCacheManager.getSingleFile(res.toString());
              }
            }
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (exception) {
      log('exception::::::::::::::::${exception}');
    }

    return allDataModel;
  }

  static Future<List<double>?> extractCoordinates(String url) async {
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

  Future<String> getAddressFromCoordinatesFromPackage(List<double> coordinates) async {
    try {
      GeoCode geoCode = GeoCode();

      Address address = await geoCode.reverseGeocoding(
        latitude: coordinates.first,
        longitude: coordinates.last,
      );
      if (address.toString().contains("Throttled")) {
        return getAddressFromCoordinatesFromPackage(coordinates);
      }
      String formattedAddress =
          "${address.streetNumber ?? ""}${address.streetNumber == null ? "" : ", "}${address.streetAddress ?? ""}${address.streetAddress == null ? "" : ", "}${address.city ?? ""}${address.streetAddress == null && address.countryName != null ? "" : ", "}${address.countryName}";

      return formattedAddress;
    } catch (error) {
      return '';
    }
  }
}
