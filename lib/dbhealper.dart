import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:simplenote/mynote.dart';

class dbhealper {
  static final dbhealper _instance = new dbhealper.internal();
  dbhealper.internal();

  factory dbhealper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "SimpleNoetDB");
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE mynote(id INTEGER PRIMARY KEY,title Text, note TEXT, createDate TEXT, updateDate TEXT, sortDate TEXT)");
    print("DB Created");
  }

  Future<int> saveNote(Mynote mynote) async {
    var dbClient = await db;
    int res = await dbClient.insert("mynote", mynote.toMap());
    print("data inserted");
    return res;
  }
}
