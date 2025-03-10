import 'dart:convert';

ReservationModel reservationModelFromJson(String str) => ReservationModel.fromJson(json.decode(str));

String reservationModelToJson(ReservationModel data) => json.encode(data.toJson());

class ReservationModel {
  Disponibilit? disponibilit;
  int? lastModifyHours;
  int? lastReservaionInMinutes;
  int? maximumGroup;
  int? numerSeatsPerService;
  int? prenotaFinoA;
  int? reservationAdvanceDays;
  bool? richiediConferma;
  String? status;

  ReservationModel({
    this.disponibilit,
    this.lastModifyHours,
    this.lastReservaionInMinutes,
    this.maximumGroup,
    this.numerSeatsPerService,
    this.prenotaFinoA,
    this.reservationAdvanceDays,
    this.richiediConferma,
    this.status,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) => ReservationModel(
        disponibilit: json["Disponibilità"] == null ? null : Disponibilit.fromJson(json["Disponibilità"]),
        lastModifyHours: json["LastModifyHours"] ?? 0,
        lastReservaionInMinutes: json["LastReservaionInMinutes"] ?? 0,
        maximumGroup: json["MaximumGroup"] ?? 0,
        numerSeatsPerService: json["NumerSeatsPerService"] ?? 0,
        prenotaFinoA: json["PrenotaFinoA"] ?? 0,
        reservationAdvanceDays: json["ReservationAdvanceDays"] ?? 0,
        richiediConferma: json["RichiediConferma"] ?? false,
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Disponibilità": disponibilit?.toJson(),
        "LastModifyHours": lastModifyHours,
        "LastReservaionInMinutes": lastReservaionInMinutes,
        "MaximumGroup": maximumGroup,
        "NumerSeatsPerService": numerSeatsPerService,
        "PrenotaFinoA": prenotaFinoA,
        "ReservationAdvanceDays": reservationAdvanceDays,
        "RichiediConferma": richiediConferma,
        "status": status,
      };
}

class Disponibilit {
  Map<String, int>? friday;
  Map<String, int>? monday;
  Map<String, int>? saturday;
  Map<String, int>? sunday;
  Map<String, int>? thursday;
  Map<String, int>? tuesday;
  Map<String, int>? wednesday;

  Disponibilit({
    this.friday,
    this.monday,
    this.saturday,
    this.sunday,
    this.thursday,
    this.tuesday,
    this.wednesday,
  });

  factory Disponibilit.fromJson(Map<String, dynamic> json) => Disponibilit(
        friday: json["Friday"] == null ? {} : Map.from(json["Friday"]!).map((k, v) => MapEntry<String, int>(k, v)),
        monday: json["Monday"] == null ? {} : Map.from(json["Monday"]!).map((k, v) => MapEntry<String, int>(k, v)),
        saturday:
            json["Saturday"] == null ? {} : Map.from(json["Saturday"]!).map((k, v) => MapEntry<String, int>(k, v)),
        sunday: json["Sunday"] == null ? {} : Map.from(json["Sunday"]!).map((k, v) => MapEntry<String, int>(k, v)),
        thursday:
            json["Thursday"] == null ? {} : Map.from(json["Thursday"]!).map((k, v) => MapEntry<String, int>(k, v)),
        tuesday: json["Tuesday"] == null ? {} : Map.from(json["Tuesday"]!).map((k, v) => MapEntry<String, int>(k, v)),
        wednesday:
            json["Wednesday"] == null ? {} : Map.from(json["Wednesday"]!).map((k, v) => MapEntry<String, int>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "Friday": Map.from(friday!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "Monday": Map.from(monday!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "Saturday": Map.from(saturday!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "Sunday": Map.from(sunday!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "Thursday": Map.from(thursday!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "Tuesday": Map.from(tuesday!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "Wednesday": Map.from(wednesday!).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
