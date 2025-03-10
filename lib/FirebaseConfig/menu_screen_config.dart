import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:urestaurants_user/Constant/shared_pref.dart';

class MenuConfig {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
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
        _notifyPageFoundChanged();
      }
    } catch (e) {
      log('e=====sectionData=====>>>>>$e');
      pageFound = false;
      _notifyPageFoundChanged();
    }
    return null;
  }

  Future<Object?> itemData() async {
    try {
      String id = preferences.getString(SharedPreference.id) ?? "01";
      DatabaseReference configRef = _databaseRef.child('$id/Items');
      final snapshot = await configRef.get();
      if (snapshot.exists) {
        pageFound = true;
        _notifyPageFoundChanged();
        return snapshot.value;
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

  void _notifyPageFoundChanged() {
    if (onPageFoundChanged != null) {
      onPageFoundChanged!(pageFound);
    }
  }
}
