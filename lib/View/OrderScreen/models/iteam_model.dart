class ItemModel {
  String priceM;
  String cod;
  String priorita;
  String ingredienti;
  String priceD;
  String codMaxi;
  String name;

  ItemModel({
    required this.priceM,
    required this.cod,
    required this.priorita,
    required this.ingredienti,
    required this.priceD,
    required this.codMaxi,
    required this.name,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      priceM: json["priceM"] ?? "",
      cod: json["COD"] ?? "",
      priorita: json["Priorità"] ?? "",
      ingredienti: json["Ingredienti"] ?? "",
      priceD: json["priceD"] ?? "",
      codMaxi: json["CODMaxi"] ?? "",
      name: json["Name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "priceM": priceM,
      "COD": cod,
      "Priorità": priorita,
      "Ingredienti": ingredienti,
      "priceD": priceD,
      "CODMaxi": codMaxi,
      "Name": name,
    };
  }

  static List<ItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ItemModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ItemModel> list) {
    return list.map((item) => item.toJson()).toList();
  }
}
