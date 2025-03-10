import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Constant/shared_pref.dart';

class InfoConfig {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: "https://al-tarcentino.firebaseio.com/").ref();

  final DatabaseReference _detailsRef =
      FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: "https://al-tarcentino-data.europe-west1.firebasedatabase.app/").ref();

  Future<Object?> infoData() async {
    try {
      DatabaseReference configRef = _detailsRef.child('Info');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        return snapshot.value;
      }
    } catch (e) {
      log('Error Info Data :::::::::::::::::  $e');
    }
    return null;
  }

  Future<Object?> exceptionsData(String? id) async {
    try {
      DatabaseReference configRef = _detailsRef.child('Exceptions');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        return snapshot.value;
      }
    } catch (e) {
      log('Error Exceptions Data ::::::::::::::::::::  $e');
    }
    return null;
  }

  Future<void> addUserData({required Map<String, dynamic> body, required String id}) async {
    try {
      log('id::::::::::::::::${id}');
      DatabaseReference userRef = _databaseRef.child(id);
      await userRef.set(body);
      log('New user added with ID: ${userRef.key}');
    } catch (e) {
      log('Error Add User Data ::::::::::::::::::::  $e');
    }
  }

  Future<Object?> getUserData({required String id}) async {
    try {
      DatabaseReference userRef = _databaseRef.child(id);
      final snapshot = await userRef.get();
      log('snapshot::::::::::::::::${jsonEncode(snapshot)}');
      if (snapshot.exists) {
        return snapshot.value;
      } else {
        return null;
      }
    } catch (e) {
      log('Error Get User Data ::::::::::::::::::::  $e');
    }
    return null;
  }

  Future<bool> deleteUserData({required String id}) async {
    try {
      await _databaseRef.child(id).remove();
      return true;
    } catch (e) {
      log('Error Get User Data ::::::::::::::::::::  $e');
    }
    return false;
  }

  Future<bool> checkDataVersion() async {
    try {
      DatabaseReference configRef = _detailsRef.child('Info');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));

        if (data.containsKey("version")) {
          String databaseVersion = preferences.getString(SharedPreference.databaseVersion) ?? "";
          preferences.putString(SharedPreference.databaseVersion, data["version"].toString());
          if (databaseVersion.isNotEmpty) {
            return databaseVersion == data["version"];
          }
        }
      }
    } catch (e) {
      log('Error Info Data :::::::::::::::::  $e');
    }
    return false;
  }
}
