class UserResponseModel {
  final String email;
  final String telefono;
  final String nome;
  final String cognome;
  final String place;

  UserResponseModel({
    required this.email,
    required this.telefono,
    required this.nome,
    required this.cognome,
    required this.place,
  });

  // Factory method to create an instance from JSON
  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      email: json['Email'] as String,
      telefono: json['Telefono'] as String,
      nome: json['Nome'] as String,
      cognome: json['Cognome'] as String,
      place: json['Place'] as String,
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Telefono': telefono,
      'Nome': nome,
      'Cognome': cognome,
      'Place': place,
    };
  }
}
