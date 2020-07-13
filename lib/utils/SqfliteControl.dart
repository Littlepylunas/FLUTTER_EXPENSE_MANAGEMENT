import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteControl {
  final String dbName = 'my_db';
  final int dbVersion = 1;

  // Table expenses
  static final String tableExpense = 'expenses';
  static final String columnExpenseId = '_id';
  static final String columnContentName = 'content_name';
  static final String columnContentType = 'content_type';
  static final String columnTitle = 'title';
  static final String columnAmount = 'amount';
  static final String columnDate = 'date';
  static final String columnPictureCode = 'picture_id';

  // Table pictures
  static final String tablePicture = 'pictures';
  static final String columnPictureId = '_id';
  static final String columnBase64 = 'base64';

  // make this a singleton class
  SqfliteControl._privateContructor();
  static final SqfliteControl instance = SqfliteControl._privateContructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  // SQL code to create the database tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableExpense (
            $columnExpenseId TEXT PRIMARY KEY,
            $columnContentName TEXT NOT NULL,
            $columnContentType INT NOT NULL,
            $columnTitle TEXT,
            $columnAmount NUM NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnPictureCode TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $tablePicture (
            $columnPictureId TEXT PRIMARY KEY,
            $columnBase64 TEXT NOT NULL
          )
          ''');
  }

  // Helper methods
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>> queryOneRow(
      String tableName, String whereCol, String whereValue) async {
    Database db = await instance.database;
    List<Map> maps = await db
        .query(tableName, where: '$whereCol = ?', whereArgs: [whereValue]);
    return maps.first;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String tableName) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, String tableName) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(
      Map<String, dynamic> row, String tableName, String whereCol) async {
    Database db = await instance.database;
    return await db.update(tableName, row,
        where: '$whereCol = ?', whereArgs: [row[whereCol]]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(
      Map<String, dynamic> row, String tableName, String whereCol) async {
    Database db = await instance.database;
    return await db
        .delete(tableName, where: '$whereCol = ?', whereArgs: [row[whereCol]]);
  }

  Future close() async => _database.close();
}
