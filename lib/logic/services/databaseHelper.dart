import 'dart:io';

import 'package:path/path.dart';
import 'package:reservation_tracking/logic/data/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  static Future<Database>? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = _initDatabase();
    return _database!;
  }

  Future<Database> get loginDatabase async {
    if (_database != null) {
      return _database!;
    }

    _database = _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
          CREATE TABLE UsersList (
            Sr_No  INTEGER PRIMARY KEY AUTOINCREMENT,
            EmailId VARCHAR(50) NOT NULL, 
            Password VARCHAR(20) NOT NULL
          )
          ''',
    );
    await db.execute(
      '''
          CREATE TABLE Reservation (
            Sr_No  INTEGER PRIMARY KEY AUTOINCREMENT,
            TrainID VARCHAR(200) NOT NULL,
            Source VARCHAR(200) NOT NULL,
            Destination VARCHAR(200) NOT NULL,
            AgeofPassenger INT NOT NULL,
            DateofTravel DATETIME NOT NULL
          )
          ''',
    );
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<User?> login(String emailId, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT * FROM UsersList where EmailId = '$emailId' and Password = '$password'");
    if (result.isNotEmpty) {
      return User.fromMap(result[0]);
    }
  }

  Future<List<Map<String, dynamic>>> fetch(String table) async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT * FROM $table");
  }
}
