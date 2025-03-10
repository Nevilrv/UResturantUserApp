class Ingredient {
  final double? pricePlusD;
  final int? cod;
  final int? priorita;
  final int? codMaxi;
  final double? pricePlusM;
  final String? name;

  Ingredient({
    this.pricePlusD,
    this.cod,
    this.priorita,
    this.codMaxi,
    this.pricePlusM,
    this.name,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      pricePlusD: double.tryParse(json['PricePlusD']) ?? 0,
      cod: json['COD'] is int ? json['COD'] : int.tryParse(json['COD'].toString()),
      priorita: json['Priorità'] is int ? json['Priorità'] : int.tryParse(json['Priorità'].toString()),
      codMaxi: json['CODMaxi'] is int ? json['CODMaxi'] : int.tryParse(json['CODMaxi'].toString()),
      pricePlusM: json['PricePlusM'] != "" ? double.tryParse(json['PricePlusM']) : 0,
      name: json['Name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PricePlusD': pricePlusD,
      'COD': cod,
      'Priorità': priorita,
      'CODMaxi': codMaxi,
      'PricePlusM': pricePlusM,
      'Name': name,
    };
  }
}
