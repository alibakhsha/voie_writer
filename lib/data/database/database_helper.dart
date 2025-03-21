import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();
  // متد برای دسترسی به دیتابیس
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // ساخت و مقداردهی اولیه دیتابیس
  Future<Database> _initDatabase() async {

    // String databasesPath = await getDatabasesPath();
    final documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = p.join(databasesPath, 'VoiceWriter_database.db');
    String path = p.join(documentsDirectory.path, 'VoiceWriter_database.db');
    // باز کردن یا ساخت دیتابیس
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user INTEGER ,
            title TEXT ,
            transcript TEXT,
            created_at TEXT
          )
        ''');
      },
    );
  }

  // متد برای درج داده
  Future<int> insertItem(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('items', row);
  }
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }


  // متد برای خوندن همه داده‌ها
  Future<List<Map<String, dynamic>>> getAllItems() async {
    final db = await database;
    return await db.query('items');
  }






  Future<void> close() async {
    final db = await database;
    db.close();
  }


  //
  // static Future<bool> checkDatabaseExists() async {
  //   final documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = p.join(documentsDirectory.path, 'VoiceWriter_database.db');
  //   return File(path).exists();
  // }



}