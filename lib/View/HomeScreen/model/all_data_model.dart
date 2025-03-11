import 'package:urestaurants_user/View/InfoScreen/Model/info_data_model.dart';
import 'package:urestaurants_user/View/MenuScreen/Model/item_data_model.dart';
import 'package:urestaurants_user/View/MenuScreen/Model/section_data_model.dart';

class Config {
  final List<SectionDataModel>? sections;

  Config({this.sections});

  factory Config.fromJson(Map<String, dynamic> json) {
    if (json['Sections'] != null) {
      (json['Sections'] as List<dynamic>?)?.removeWhere(
        (element) => element == null,
      );
    }
    return Config(
      sections: (json['Sections'] as List<dynamic>?)?.map((e) => SectionDataModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Sections': sections?.map((e) => e.toJson()).toList(),
    };
  }
}

class AllDataModel {
  final Config? config;
  final Map<String, dynamic>? exceptions;
  final Map<String, dynamic>? favorites;
  final InfoDataModel? info;
  final List<ItemDataModel>? items;
  final String? id;
  double? lat;
  double? long;
  String? fullAddress;

  AllDataModel({
    this.config,
    this.exceptions,
    this.favorites,
    this.info,
    this.items,
    this.id,
    this.lat,
    this.long,
    this.fullAddress,
  });

  // Convert JSON to AllDataModel
  factory AllDataModel.fromJson(Map<String, dynamic> json, String key) {
    if (json['Items'] != null) {
      (json['Items'] as List).removeWhere(
        (element) => element == null,
      );
    }
    return AllDataModel(
        config: json['Config'] != null ? Config.fromJson(json['Config'] as Map<String, dynamic>) : null,
        exceptions: json['Exceptions'] as Map<String, dynamic>?,
        favorites: json['Favorites'] as Map<String, dynamic>?,
        info: json['Info'] != null ? InfoDataModel.fromJson(json['Info'] as Map<String, dynamic>) : null,
        items: json['Items'] != null
            ? List<ItemDataModel>.from(json['Items'].map((e) {
                return ItemDataModel.fromJson(e as Map<String, dynamic>);
              }))
            : null,
        id: key,
        lat: json['lat'],
        long: json['long'],
        fullAddress: json['fullAddress']);
  }

  // Convert AllDataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'Config': config,
      'Exceptions': exceptions,
      'Favorites': favorites,
      'Info': info,
      'Items': items,
      'id': id,
      'lat': lat,
      'long': long,
      'fullAddress': fullAddress,
    };
  }
}
