import 'package:shared_preferences/shared_preferences.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const isLogin = "IS_LOGGED_IN";
  // static const userId = "USER_ID";
  static const userId = "USER_ID";
  static const userFirstName = "USER_FIRST_NAME";
  static const userLastName = "USER_LAST_NAME";
  static const userEmail = "USER_EMAIL";
  static const id = "RESTRO_ID";
  static const restroName = "RESTRO_NAME";
  static const currentPage = "CURRENT_PAGE";
  static const reservationData = "RESERVATION_DATA";

  static const sectionData = "SECTION_DATA";
  static const itemData = "ITEM_DATA";
  static const hotelData = "HOTEL_DATA";
  static const hotelAddress = "HOTEL_ADDRESS";
  static const hotelLat = "HOTEL_LAT";
  static const hotelLong = "HOTEL_LONG";
  static const exceptionsData = "EXCEPTION_DATA";
  static const orderData = "ORDER_DATA";
  static const pizzaItemData = "PIZZA_ITEM_DATA";
  static const ingredientData = "INGREDIENT_DATA";
  static const databaseVersion = "DATABASE_VERSION";
  static const isFirstTime = "IS_FIRST_TIME";

  logOut() {
    _preferences?.remove(SharedPreference.isLogin);
    _preferences?.remove(SharedPreference.userId);
    _preferences?.remove(SharedPreference.userFirstName);
    _preferences?.remove(SharedPreference.userLastName);
    _preferences?.remove(SharedPreference.userEmail);
    _preferences?.remove(SharedPreference.orderData);
  }

  Future<bool?> putString(String key, String value) async {
    return _preferences?.setString(key, value);
  }

  String? getString(String key, {String defValue = ""}) {
    return _preferences == null ? defValue : _preferences!.getString(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    return _preferences?.setInt(key, value);
  }

  int? getInt(String key, {int defValue = 0}) {
    return _preferences == null ? defValue : _preferences!.getInt(key) ?? defValue;
  }

  Future<bool?> putDouble(String key, double value) async {
    return _preferences?.setDouble(key, value);
  }

  double getDouble(String key, {double defValue = 0.0}) {
    return _preferences == null ? defValue : _preferences!.getDouble(key) ?? defValue;
  }

  Future<bool?> putBool(String key, bool value) async {
    return _preferences?.setBool(key, value);
  }

  bool? getBool(String key, {bool defValue = false}) {
    return _preferences == null ? defValue : _preferences!.getBool(key) ?? defValue;
  }

  Future<void> removeOneData(String key) async {
    await _preferences?.remove(key);
  }
}
