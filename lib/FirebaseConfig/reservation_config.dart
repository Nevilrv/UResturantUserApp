import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';
import 'package:urestaurants_user/View/Reservation/Model/reservation_model.dart';

class ReservationConfig {
  final DatabaseReference _databaseRef = FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: "https://urestaurants-reservations.europe-west1.firebasedatabase.app")
      .ref();

  bool status = false;
  final Function(bool)? isActive;
  ReservationConfig({this.isActive});

  Future<Object?> getReservationStatus() async {
    try {
      String id = preferences.getString(SharedPreference.id) ?? "01";
      DatabaseReference configRef = _databaseRef.child('${id}S');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        final data = ReservationModel.fromJson(jsonDecode(jsonEncode(snapshot.value)));
        preferences.putString(SharedPreference.reservationData, jsonEncode(data));
        status = data.status == "active";
        _notifyStatusChanged();
        return snapshot.value;
      } else {
        status = false;
        _notifyStatusChanged();
      }
    } catch (e) {
      log('e=====reservationError=====>>>>>$e');
      status = false;
      _notifyStatusChanged();
    }
    return null;
  }

  void _notifyStatusChanged() {
    if (isActive != null) {
      isActive!(status);
    }
  }
}
