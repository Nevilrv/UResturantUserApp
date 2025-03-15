import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:urestaurants_user/FirebaseConfig/common_config.dart';
import 'package:urestaurants_user/Utils/cache_manager.dart';
import 'package:urestaurants_user/Utils/geo_coding_service.dart';
import 'package:urestaurants_user/Utils/sql_helper.dart';
import 'package:urestaurants_user/View/HomeScreen/model/all_data_model.dart';

// class RestaurentConfig {
//   final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
//   final CustomCacheManager _customCacheManager = CustomCacheManager();
//   final Map<String, String> _imageCache = {};
//   final Map<String, String> _addressCache = {};
//
//   Future<List<AllDataModel>> getData() async {
//     try {
//       DataSnapshot dataSnapshot = await _databaseRef.once().then((event) => event.snapshot);
//       if (dataSnapshot.value == null) return [];
//       Map<String, dynamic> decodedData = jsonDecode(jsonEncode(dataSnapshot.value));
//       decodedData.removeWhere((key, value) => !_isValidEntry(key, value));
//       List<AllDataModel> allDataList = decodedData.entries.map((entry) {
//         return AllDataModel.fromJson(entry.value, entry.key);
//       }).toList();
//       await Future.wait(allDataList.map(_processRestaurantData));
//       return allDataList;
//     } catch (error) {
//       log('Error fetching restaurant data: $error');
//       return [];
//     }
//   }
//
//   bool _isValidEntry(String key, dynamic value) {
//     return int.tryParse(key) != null && value['Info']?['isActive'] == true;
//   }
//
//   Future<void> _processRestaurantData(AllDataModel data) async {
//     try {
//       await Future.wait([
//         _cacheImageIfMissing(data),
//         _fetchLocationDetails(data),
//         _processSectionImages(data),
//       ]);
//     } catch (error) {
//       log('Error processing restaurant ${data.id}: $error');
//     }
//   }
//
//   Future<void> _cacheImageIfMissing(AllDataModel data) async {
//     data.info?.logoUrl ??= await CommonConfig().loadImage("ImagePlaces", data.id ?? "01", "jpg");
//     if (_isValidUrl(data.info?.logoUrl)) {
//       _customCacheManager.getSingleFile(data.info!.logoUrl!);
//     }
//   }
//
//   Future<void> _fetchLocationDetails(AllDataModel data) async {
//     List<double>? coordinates = await extractCoordinates(data.info?.urlMaps ?? "");
//     if (coordinates == null || coordinates.length != 2) return;
//
//     data.lat = coordinates[0];
//     data.long = coordinates[1];
//
//     String coordinateKey = "${data.lat},${data.long}";
//
//     if (_addressCache.containsKey(coordinateKey)) {
//       data.fullAddress = _addressCache[coordinateKey]!;
//     } else {
//       final lat = data.lat ?? 0.0;
//       final long = data.long ?? 0.0;
//       if (lat != 0.0 && long != 0.0) {
//         data.fullAddress = await GoogleGeocodingService.getAddressFromCoordinates(lat, long);
//         _addressCache[coordinateKey] = data.fullAddress ?? "";
//       } else {
//         data.fullAddress = "Invalid Coordinates";
//       }
//     }
//   }
//
//   Future<void> _processSectionImages(AllDataModel data) async {
//     if (data.config?.sections == null) return;
//
//     await Future.wait(data.config!.sections!.map((section) async {
//       if ((section.imageUrl?.isEmpty ?? true)) {
//         if (_imageCache.containsKey(section.name)) {
//           section.imageUrl = _imageCache[section.name];
//         } else {
//           section.imageUrl = await CommonConfig().loadImage("sectionImages", section.name ?? "", "jpeg");
//           if (_isValidUrl(section.imageUrl)) {
//             _imageCache[section.name ?? ""] = section.imageUrl!;
//             _customCacheManager.getSingleFile(section.imageUrl!);
//           }
//         }
//       }
//     }));
//   }
//
//   static Future<List<double>?> extractCoordinates(String url) async {
//     try {
//       Uri uri = Uri.tryParse(url) ?? Uri();
//       String? latLong = uri.queryParameters['ll'];
//       if (latLong != null) {
//         List<String> parts = latLong.split(',');
//         if (parts.length == 2) {
//           return [double.parse(parts[0]), double.parse(parts[1])];
//         }
//       }
//     } catch (e) {
//       debugPrint('Error parsing coordinates: $e');
//     }
//     return null;
//   }
//
//   bool _isValidUrl(String? url) {
//     return url != null && Uri.tryParse(url)?.hasAbsolutePath == true;
//   }
// }

class RestaurentConfig {
  DatabaseHelper dbHelper = DatabaseHelper();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final CustomCacheManager _customCacheManager = CustomCacheManager();
  final Map<String, String> _imageCache = {};
  final Map<String, String> _addressCache = {};

  Future getData() async {
    try {
      DataSnapshot dataSnapshot = await _databaseRef.once().then((event) => event.snapshot);
      if (dataSnapshot.value == null) return [];
      Map<String, dynamic> decodedData = jsonDecode(jsonEncode(dataSnapshot.value));
      decodedData.removeWhere((key, value) => !_isValidEntry(key, value));
      List<AllDataModel> allDataList = decodedData.entries.map((entry) {
        return AllDataModel.fromJson(entry.value, entry.key);
      }).toList();

      for (var mainData in allDataList) {
        try {
          List<Map<String, dynamic>> data =
              await dbHelper.getDataFromTable(tableName: DatabaseHelper.restaurant, where: "id", id: mainData.id ?? "");

          if (data.isNotEmpty) {
            dbHelper.updateData(
                tableName: DatabaseHelper.restaurant,
                data: {
                  "config": jsonEncode(mainData.config?.toJson()),
                  "items": jsonEncode(mainData.items),
                  "info": jsonEncode(mainData.info?.toJson()),
                  "exception": jsonEncode(mainData.exceptions),
                  "image": mainData.info?.logoUrl ?? "",
                  "lat": "",
                  "lang": "",
                  "fulladdress": ""
                },
                where: "id",
                id: mainData.id ?? "");
          } else {
            dbHelper.insertData(tableName: DatabaseHelper.restaurant, data: {
              "id": mainData.id,
              "config": jsonEncode(mainData.config?.toJson()),
              "items": jsonEncode(mainData.items),
              "info": jsonEncode(mainData.info?.toJson()),
              "exception": jsonEncode(mainData.exceptions),
              "image": mainData.info?.logoUrl ?? "",
              "lat": "",
              "lang": "",
              "fulladdress": ""
            });
          }
          _processRestaurantData(mainData);
        } catch (error) {}
      }

      // await Future.wait(allDataList.map(_processRestaurantData));
      return allDataList;
    } catch (error) {
      log('Error fetching restaurant data: $error');
      return [];
    }
  }

  bool _isValidEntry(String key, dynamic value) {
    return int.tryParse(key) != null && value['Info']?['isActive'] == true;
  }

  Future<void> _processRestaurantData(AllDataModel data) async {
    try {
      await Future.wait([
        _cacheImageIfMissing(data),
        _fetchLocationDetails(data),
        _processSectionImages(data),
      ]);
    } catch (error) {
      log('Error processing restaurant ${data.id}: $error');
    }
  }

  Future<void> _cacheImageIfMissing(AllDataModel data) async {
    if (_isValidUrl(data.info?.logoUrl)) {
      _customCacheManager.getSingleFile(data.info!.logoUrl!);
    }
  }

  Future<void> _fetchLocationDetails(AllDataModel data) async {
    List<double>? coordinates = await extractCoordinates(data.info?.urlMaps ?? "");
    if (coordinates == null || coordinates.length != 2) return;

    data.lat = coordinates[0];
    data.long = coordinates[1];

    String coordinateKey = "${data.lat},${data.long}";

    if (_addressCache.containsKey(coordinateKey)) {
      data.fullAddress = _addressCache[coordinateKey]!;
    } else {
      final lat = data.lat ?? 0.0;
      final long = data.long ?? 0.0;
      if (lat != 0.0 && long != 0.0) {
        data.fullAddress = await GoogleGeocodingService.getAddressFromCoordinates(lat, long);
        _addressCache[coordinateKey] = data.fullAddress ?? "";
      } else {
        data.fullAddress = "Invalid Coordinates";
      }

      dbHelper.updateData(
          tableName: DatabaseHelper.restaurant,
          where: "id",
          data: {"fullAddress": data.fullAddress, "lat": data.lat, "lang": data.long},
          id: data.id ?? "");
    }
  }

  Future<void> _processSectionImages(AllDataModel data) async {
    if (data.config?.sections == null) return;

    await Future.wait(data.config!.sections!.map((section) async {
      if ((section.imageUrl?.isEmpty ?? true)) {
        if (!_imageCache.containsKey(section.name)) {
          section.imageUrl = await CommonConfig().loadImage("sectionImages", section.name ?? "", "jpeg");
          if (_isValidUrl(section.imageUrl)) {
            _imageCache[section.name ?? ""] = section.imageUrl!;
            _customCacheManager.getSingleFile(section.imageUrl!);

            dbHelper.insertData(tableName: DatabaseHelper.section, data: {"section": section.name, "image": section.imageUrl});
          }
        }
      }
    }));
  }

  static Future<List<double>?> extractCoordinates(String url) async {
    try {
      Uri uri = Uri.tryParse(url) ?? Uri();
      String? latLong = uri.queryParameters['ll'];
      if (latLong != null) {
        List<String> parts = latLong.split(',');
        if (parts.length == 2) {
          return [double.parse(parts[0]), double.parse(parts[1])];
        }
      }
    } catch (e) {
      debugPrint('Error parsing coordinates: $e');
    }
    return null;
  }

  bool _isValidUrl(String? url) {
    return url != null && Uri.tryParse(url)?.hasAbsolutePath == true;
  }
}
