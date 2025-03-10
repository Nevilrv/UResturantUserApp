// To parse this JSON data, do
//
//     final infoDataModel = infoDataModelFromJson(jsonString);

import 'dart:convert';

InfoDataModel infoDataModelFromJson(String str) => InfoDataModel.fromJson(json.decode(str));

String infoDataModelToJson(InfoDataModel data) => json.encode(data.toJson());

class InfoDataModel {
  String? the001Monday;
  String? the002Tuesday;
  String? the003Wednesday;
  String? the004Thursday;
  String? the005Friday;
  String? the006Saturday;
  String? the007Sunday;
  String? appClipMode;
  String? atr1;
  String? atr2;
  String? city;
  String? googleId;
  bool? isActive;
  String? logoUrl;
  String? mode;
  String? nome;
  String? password;
  String? ssid;
  String? star;
  String? telefono;
  String? urlGMaps;
  String? urlMaps;
  String? version;

  InfoDataModel({
    this.the001Monday,
    this.the002Tuesday,
    this.the003Wednesday,
    this.the004Thursday,
    this.the005Friday,
    this.the006Saturday,
    this.the007Sunday,
    this.appClipMode,
    this.atr1,
    this.atr2,
    this.city,
    this.googleId,
    this.isActive,
    this.logoUrl,
    this.mode,
    this.nome,
    this.password,
    this.ssid,
    this.star,
    this.telefono,
    this.urlGMaps,
    this.urlMaps,
    this.version,
  });

  factory InfoDataModel.fromJson(Map<String, dynamic> json) => InfoDataModel(
        the001Monday: json["001-Monday"],
        the002Tuesday: json["002-Tuesday"],
        the003Wednesday: json["003-Wednesday"],
        the004Thursday: json["004-Thursday"],
        the005Friday: json["005-Friday"],
        the006Saturday: json["006-Saturday"],
        the007Sunday: json["007-Sunday"],
        appClipMode: json["appClipMode"],
        atr1: json["atr1"],
        atr2: json["atr2"],
        city: json["city"],
        googleId: json["googleId"],
        isActive: json["isActive"],
        logoUrl: json["logoUrl"],
        mode: json["mode"],
        nome: json["nome"],
        password: json["password"],
        ssid: json["ssid"],
        star: json["star"],
        telefono: json["telefono"],
        urlGMaps: json["urlGMaps"],
        urlMaps: json["urlMaps"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "001-Monday": the001Monday,
        "002-Tuesday": the002Tuesday,
        "003-Wednesday": the003Wednesday,
        "004-Thursday": the004Thursday,
        "005-Friday": the005Friday,
        "006-Saturday": the006Saturday,
        "007-Sunday": the007Sunday,
        "appClipMode": appClipMode,
        "atr1": atr1,
        "atr2": atr2,
        "city": city,
        "googleId": googleId,
        "isActive": isActive,
        "logoUrl": logoUrl,
        "mode": mode,
        "nome": nome,
        "password": password,
        "ssid": ssid,
        "star": star,
        "telefono": telefono,
        "urlGMaps": urlGMaps,
        "urlMaps": urlMaps,
        "version": version,
      };
}
