import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class InfoConfig {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final DatabaseReference _loginDatabaseRef = FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: "https://urestaurants-insight.europe-west1.firebasedatabase.app")
      .ref();

  Future<Object?> infoData(String? id) async {
    try {
      DatabaseReference configRef = _databaseRef.child('$id/Info');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        return snapshot.value;
      }
    } catch (e) {
      log('e=====sectionData=====>>>>>$e');
    }
    return null;
  }

  Future<Object?> exceptionsData(String? id) async {
    try {
      DatabaseReference configRef = _databaseRef.child('$id/Exceptions');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        return snapshot.value;
      }
    } catch (e) {
      log('e=====sectionData=====>>>>>$e');
    }
    return null;
  }

  Future<void> addUserData({required Map<String, dynamic> body, required String id}) async {
    try {
      DatabaseReference userRef = _loginDatabaseRef.child('Auth').child(id);
      await userRef.set(body);
      log('New user added with ID: ${userRef.key}');
    } catch (e) {
      log('e=====addNewUser=====>>>>>$e');
    }
  }

  Future<Object?> getUserData({required String id}) async {
    try {
      DatabaseReference userRef = _loginDatabaseRef.child('Auth').child(id);
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        return snapshot.value;
      } else {
        return null;
      }
    } catch (e) {
      log('e=====getUserData=====>>>>>$e');
    }
    return null;
  }
}
