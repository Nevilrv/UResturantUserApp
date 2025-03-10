import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthConfig {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final DatabaseReference _loginDatabaseRef =
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: "https://urestaurants-insight.europe-west1.firebasedatabase.app")
          .ref();

  Future<Object?> userData(String? id) async {
    try {
      DatabaseReference configRef = _loginDatabaseRef.child('Business/$id');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        return snapshot.value;
      }
    } catch (e) {
      log('e=====userData=====>>>>>$e');
    }
    return null;
  }
}
