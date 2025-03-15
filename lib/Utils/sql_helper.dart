import 'package:path/path.dart' as path1;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String restaurant = "Restaurant";
  static const String section = "Section";

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = path1.join(documentsDirectory.path, 'MainDataDB.db');
    return await openDatabase(path, version: 2, onCreate: _createDatabase);
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $restaurant (
    
        id TEXT PRIMARY KEY,
        config TEXT,
        items TEXT,
        info TEXT,
        exception TEXT,
        lat TEXT,
        lang TEXT,
        fulladdress TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $section (
        id INTEGER PRIMARY KEY autoincrement,
        section TEXT,
        image TEXT
      )
    ''');
  }

  Future<int> insertData({required String tableName, required Map<String, dynamic> data}) async {
    Database db = await database;
    return await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> fetchData({required String tableName}) async {
    Database db = await database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> getDataFromTable({required String tableName, required String where, required String id}) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(tableName, where: '$where = ?', whereArgs: [id]);
    return results;
  }

  Future<List<Map<String, dynamic>>> getAllTableData({required String tableName}) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
    );
    return results;
  }

  Future<int> updateData({required String tableName, required String where, required Map<String, dynamic> data, required String id}) async {
    Database db = await database;
    return await db.update(tableName, data, where: '$where = ?', whereArgs: [id]);
  }

  Future<int> updateSingleValue(
      {required String tableName,
      required String columnName,
      required dynamic newValue,
      required dynamic id,
      String idField = "dataId"}) async {
    Database db = await database;
    return await db.update(
      tableName,
      {columnName: newValue},
      where: '$idField = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSingleData({required String tableName, required String id, required String where}) async {
    Database db = await database;
    return await db.delete(
      tableName,
      where: '$where = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllData(String tableName) async {
    Database db = await database;
    await db.delete(tableName);
  }
}
