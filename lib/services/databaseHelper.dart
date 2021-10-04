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
            Name VARCHAR(50) NOT NULL,
            EmailId VARCHAR(50) NOT NULL, 
            Password VARCHAR(20) NOT NULL
          )
          ''',
    );
    await db.execute(
      '''
          CREATE TABLE Reservation (
            Sr_No  INTEGER PRIMARY KEY AUTOINCREMENT,
            CustomerID VARCHAR(200) NOT NULL, 
            TrainID VARCHAR(200) NOT NULL,
            Source VARCHAR(200) NOT NULL,
            Destination VARCHAR(200) NOT NULL,
            AgeofPassenger INT NOT NULL,
            DateofTravel DATETIME NOT NULL,
            FOREIGN KEY(CustomerID) REFERENCES UsersList(Sr_No),
            FOREIGN KEY(TrainID) REFERENCES Trains(Sr_No)

          )
          ''',
    );
    await db.execute(
      '''
          CREATE TABLE Trains (
            Sr_No  INTEGER PRIMARY KEY AUTOINCREMENT,
            TrainName VARCHAR(200) NOT NULL, 
            SourceStation VARCHAR(200) NOT NULL,
            DestinationStation VARCHAR(200) NOT NULL,
            DepartureTime VARCHAR(10) NOT NULL,
            ArrivalTime VARCHAR(10) NOT NULL
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

  Future<List<Map<String, dynamic>>> fetch(String table, [String? condition]) async {
    Database db = await instance.database;
    return await db.rawQuery(condition != null ? "SELECT * FROM $table where $condition" : "SELECT * FROM $table");
  }
}
