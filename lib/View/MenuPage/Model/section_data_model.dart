import 'dart:convert';

List<SectionDataModel> sectionDataModelFromJson(String str) =>
    List<SectionDataModel>.from(json.decode(str).map((x) => SectionDataModel.fromJson(x)));

String sectionDataModelToJson(List<SectionDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SectionDataModel {
  String? imageName;
  String? name;
  String? nameRu;
  String? nameDe;
  String? nameEn;
  String? nameEs;
  String? nameFr;
  String? namePl;
  String? sectionDataModelNameRu;
  String? nameZh;
  String? nameZhHans;
  String? type;
  String? imageUrl;

  SectionDataModel({
    this.imageName,
    this.name,
    this.nameRu,
    this.nameDe,
    this.nameEn,
    this.nameEs,
    this.nameFr,
    this.namePl,
    this.sectionDataModelNameRu,
    this.nameZh,
    this.nameZhHans,
    this.type,
    this.imageUrl,
  });

  factory SectionDataModel.fromJson(Map<String, dynamic> json) => SectionDataModel(
        imageName: json["ImageName"],
        name: json["Name"],
        nameRu: json["Name!RU"],
        nameDe: json["Name!de"],
        nameEn: json["Name!en"],
        nameEs: json["Name!es"],
        nameFr: json["Name!fr"],
        namePl: json["Name!pl"],
        sectionDataModelNameRu: json["Name!ru"],
        nameZh: json["Name!zh"],
        nameZhHans: json["Name!zh-Hans"],
        type: json["Type"],
        imageUrl: json["imageUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ImageName": imageName,
        "Name": name,
        "Name!RU": nameRu,
        "Name!de": nameDe,
        "Name!en": nameEn,
        "Name!es": nameEs,
        "Name!fr": nameFr,
        "Name!pl": namePl,
        "Name!ru": sectionDataModelNameRu,
        "Name!zh": nameZh,
        "Name!zh-Hans": nameZhHans,
        "Type": type,
        "imageUrl": imageUrl,
      };
}
