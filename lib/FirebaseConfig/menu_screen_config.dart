import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Constant/shared_pref.dart';

class MenuConfig {
  final DatabaseReference _databaseRef = FirebaseDatabase.instanceFor(
          app: Firebase.app(), databaseURL: 'https://urestaurants-ebb27-default-rtdb.europe-west1.firebasedatabase.app')
      .ref();
  // final DatabaseReference _databaseRef2 =
  //     FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://al-tarcentino-85c8a.firebaseio.com/').ref();
  bool pageFound = false;

  final Function(bool)? onPageFoundChanged;
  MenuConfig({this.onPageFoundChanged});

  Future<Object?> sectionData() async {
    try {
      String id = preferences.getString(SharedPreference.id) ?? "01";
      DatabaseReference configRef = _databaseRef.child('$id/Config/Sections');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        pageFound = true;
        _notifyPageFoundChanged();
        return snapshot.value;
      } else {
        pageFound = false;
        log('pageFound::::::::::::::::${pageFound}');
        _notifyPageFoundChanged();
      }
    } catch (e) {
      log('e=====sectionData=====>>>>>$e');
      pageFound = false;
      _notifyPageFoundChanged();
    }
    return null;
  }

  Future<DataSnapshot?> itemData() async {
    try {
      String id = preferences.getString(SharedPreference.id) ?? "01";
      DatabaseReference configRef = _databaseRef.child('$id/Items');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        pageFound = true;
        _notifyPageFoundChanged();
        return snapshot;
      } else {
        pageFound = false;
        _notifyPageFoundChanged();
      }
    } catch (e) {
      log('e=====itemData=====>>>>>$e');
      pageFound = false;
      _notifyPageFoundChanged();
    }
    return null;
  }

  // Future<DataSnapshot?> itemFromAnother() async {
  //   try {
  //     DatabaseReference configRef = _databaseRef2.child('000-Items');
  //     final snapshot = await configRef.get();
  //     if (snapshot.exists) {
  //       pageFound = true;
  //       _notifyPageFoundChanged();
  //       return snapshot;
  //     } else {
  //       pageFound = false;
  //       _notifyPageFoundChanged();
  //     }
  //   } catch (e) {
  //     log('e=====itemData=====>>>>>$e');
  //     pageFound = false;
  //     _notifyPageFoundChanged();
  //   }
  //   return null;
  // }
  //
  // Future<DataSnapshot?> itemIngredient() async {
  //   try {
  //     DatabaseReference configRef = _databaseRef2.child('000-Ingredienti');
  //     final snapshot = await configRef.get();
  //     if (snapshot.exists) {
  //       return snapshot;
  //     } else {
  //       pageFound = false;
  //       _notifyPageFoundChanged();
  //     }
  //   } catch (e) {
  //     log('e=====itemData=====>>>>>$e');
  //     pageFound = false;
  //     _notifyPageFoundChanged();
  //   }
  //   return null;
  // }

  Future addItemData(Map<String, dynamic> body) async {
    String id = preferences.getString(SharedPreference.id) ?? "01";
    String key = body['key'].toString();
    await _databaseRef.child('$id/Items').child(key).set(body);
  }

  void _notifyPageFoundChanged() {
    if (onPageFoundChanged != null) {
      onPageFoundChanged!(pageFound);
    }
  }

  Future deleteItem(String id2) async {
    String id = preferences.getString(SharedPreference.id) ?? "01";
    await _databaseRef.child('$id/Items').child(id2).remove();
  }

  Future editItemData(Map<String, dynamic> body, String key) async {
    String id = preferences.getString(SharedPreference.id) ?? "01";
    await _databaseRef.child('$id/Items').child(key).set(body);
  }
}
