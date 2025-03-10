import 'dart:convert';

class Order {
  final Map<String, dynamic> dittaglio;
  final String cod;
  final String data;
  final String ora;

  Order({
    required this.dittaglio,
    required this.cod,
    required this.data,
    required this.ora,
  });

  // Factory method to create an instance from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      dittaglio: json['Dittaglio'] as Map<String, dynamic>,
      cod: json['Cod'] as String,
      data: json['Data'] as String,
      ora: json['Ora'] as String,
    );
  }

  // Convert Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Dittaglio': dittaglio,
      'Cod': cod,
      'Data': data,
      'Ora': ora,
    };
  }
}

// Convert JSON string to Order object
Order parseOrder(String jsonString) {
  final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  return Order.fromJson(jsonMap);
}

// Convert List of Orders to JSON String
String encodeOrders(List<Order> orders) {
  return jsonEncode(orders.map((order) => order.toJson()).toList());
}
