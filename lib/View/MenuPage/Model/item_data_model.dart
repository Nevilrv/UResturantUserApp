// To parse this JSON data, do
//
//     final itemDataModel = itemDataModelFromJson(jsonString);

import 'dart:convert';

List<ItemDataModel> itemDataModelFromJson(String str) =>
    List<ItemDataModel>.from(json.decode(str).map((x) => ItemDataModel.fromJson(x)));

String itemDataModelToJson(List<ItemDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemDataModel {
  String? the000Nome;
  String? the000NomeDe;
  String? the000NomeEn;
  String? the000NomeEs;
  String? the000NomeFr;
  String? the000NomePl;
  String? the000NomeZhHans;
  String? allergeni;
  String? cod;
  String? codMaxi;
  String? ingredienti;
  String? ingredientiRu;
  String? ingredientiDe;
  String? ingredientiEn;
  String? ingredientiEs;
  String? ingredientiFr;
  String? ingredientiPl;
  String? itemDataModelIngredientiRu;
  String? ingredientiZh;
  String? ingredientiZhHans;
  String? priceD;
  String? priceM;
  String? priceUSDD;
  String? priceUSDM;
  String? priceUKPD;
  String? priceUKPM;
  String? pricePOZD;
  String? pricePOZM;
  String? priceCHYD;
  String? priceCHYM;
  String? sezione;
  String? sezioneRu;
  String? sezioneDe;
  String? sezioneEn;
  String? sezioneEs;
  String? sezioneFr;
  String? sezionePl;
  String? itemDataModelSezioneRu;
  String? sezioneZh;
  String? sezioneZhHans;
  String? sezionees;
  String? subCategory;
  String? the000NomeRu;
  String? itemDataModel000NomeRu;
  String? the000NomeZh;
  String? imageAvailable;
  String? imageAVAL;

  ItemDataModel({
    this.the000Nome,
    this.the000NomeDe,
    this.the000NomeEn,
    this.the000NomeEs,
    this.the000NomeFr,
    this.the000NomePl,
    this.the000NomeZhHans,
    this.allergeni,
    this.cod,
    this.codMaxi,
    this.ingredienti,
    this.ingredientiRu,
    this.ingredientiDe,
    this.ingredientiEn,
    this.ingredientiEs,
    this.ingredientiFr,
    this.ingredientiPl,
    this.itemDataModelIngredientiRu,
    this.ingredientiZh,
    this.ingredientiZhHans,
    this.priceD,
    this.priceM,
    this.sezione,
    this.sezioneRu,
    this.sezioneDe,
    this.sezioneEn,
    this.sezioneEs,
    this.sezioneFr,
    this.sezionePl,
    this.itemDataModelSezioneRu,
    this.sezioneZh,
    this.sezioneZhHans,
    this.sezionees,
    this.subCategory,
    this.the000NomeRu,
    this.priceUSDD,
    this.priceUSDM,
    this.priceUKPD,
    this.priceUKPM,
    this.pricePOZD,
    this.pricePOZM,
    this.priceCHYD,
    this.priceCHYM,
    this.itemDataModel000NomeRu,
    this.the000NomeZh,
    this.imageAvailable,
    this.imageAVAL,
  });

  factory ItemDataModel.fromJson(Map<String, dynamic> json) => ItemDataModel(
        the000Nome: json["000-Nome"],
        the000NomeDe: json["000-Nome!de"],
        the000NomeEn: json["000-Nome!en"],
        the000NomeEs: json["000-Nome!es"],
        the000NomeFr: json["000-Nome!fr"],
        the000NomePl: json["000-Nome!pl"],
        the000NomeZhHans: json["000-Nome!zh-Hans"],
        allergeni: json["allergeni"],
        cod: json["cod"],
        codMaxi: json["codMaxi"],
        ingredienti: json["ingredienti"],
        ingredientiRu: json["ingredienti!RU"],
        ingredientiDe: json["ingredienti!de"],
        ingredientiEn: json["ingredienti!en"],
        ingredientiEs: json["ingredienti!es"],
        ingredientiFr: json["ingredienti!fr"],
        ingredientiPl: json["ingredienti!pl"],
        itemDataModelIngredientiRu: json["ingredienti!ru"],
        ingredientiZh: json["ingredienti!zh"],
        ingredientiZhHans: json["ingredienti!zh-Hans"],
        priceD: json["priceD"],
        priceM: json["priceM"],
        sezione: json["sezione"],
        sezioneRu: json["sezione!RU"],
        sezioneDe: json["sezione!de"],
        sezioneEn: json["sezione!en"],
        sezioneEs: json["sezione!es"],
        sezioneFr: json["sezione!fr"],
        sezionePl: json["sezione!pl"],
        itemDataModelSezioneRu: json["sezione!ru"],
        sezioneZh: json["sezione!zh"],
        sezioneZhHans: json["sezione!zh-Hans"],
        sezionees: json["sezionees"],
        subCategory: json["subCategory"],
        the000NomeRu: json["000-Nome!RU"],
        itemDataModel000NomeRu: json["000-Nome!ru"],
        the000NomeZh: json["000-Nome!zh"],
        imageAvailable: json["imageAvailable"],
        priceUSDD: json["priceUSDD"],
        priceUSDM: json["priceUSDM"],
        priceUKPD: json["priceUKPD"],
        priceUKPM: json["priceUKPM"],
        pricePOZD: json["pricePOZD"],
        pricePOZM: json["pricePOZM"],
        priceCHYD: json["priceCHYD"],
        priceCHYM: json["priceCHYM"],
        imageAVAL: json["imageAVAL"],
      );

  Map<String, dynamic> toJson() => {
        "000-Nome": the000Nome,
        "000-Nome!de": the000NomeDe,
        "000-Nome!en": the000NomeEn,
        "000-Nome!es": the000NomeEs,
        "000-Nome!fr": the000NomeFr,
        "000-Nome!pl": the000NomePl,
        "000-Nome!zh-Hans": the000NomeZhHans,
        "allergeni": allergeni,
        "cod": cod,
        "codMaxi": codMaxi,
        "ingredienti": ingredienti,
        "ingredienti!RU": ingredientiRu,
        "ingredienti!de": ingredientiDe,
        "ingredienti!en": ingredientiEn,
        "ingredienti!es": ingredientiEs,
        "ingredienti!fr": ingredientiFr,
        "ingredienti!pl": ingredientiPl,
        "ingredienti!ru": itemDataModelIngredientiRu,
        "ingredienti!zh": ingredientiZh,
        "ingredienti!zh-Hans": ingredientiZhHans,
        "priceD": priceD,
        "priceM": priceM,
        "sezione": sezione,
        "sezione!RU": sezioneRu,
        "sezione!de": sezioneDe,
        "sezione!en": sezioneEn,
        "sezione!es": sezioneEs,
        "sezione!fr": sezioneFr,
        "sezione!pl": sezionePl,
        "sezione!ru": itemDataModelSezioneRu,
        "sezione!zh": sezioneZh,
        "sezione!zh-Hans": sezioneZhHans,
        "sezionees": sezionees,
        "subCategory": subCategory,
        "000-Nome!RU": the000NomeRu,
        "000-Nome!ru": itemDataModel000NomeRu,
        "000-Nome!zh": the000NomeZh,
        "imageAvailable": imageAvailable,
        "priceUSDD": priceUSDD,
        "priceUSDM": priceUSDM,
        "priceUKPD": priceUKPD,
        "priceUKPM": priceUKPM,
        "pricePOZD": pricePOZD,
        "pricePOZM": pricePOZM,
        "priceCHYD": priceCHYD,
        "priceCHYM": priceCHYM,
        "imageAVAL": imageAVAL,
      };
}
