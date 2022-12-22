import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';


class SQLHelper {

  static  Future<sql.Database> db() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Todos.db');
    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    await database.execute(''' CREATE TABLE todoApp (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ''');
  }

  static Future<int> addTask(String title, String? description) async {
    final db = await SQLHelper.db();
    final data = {'title' : title, 'description' : description, 'createdAt' : DateTime.now().toString()};
    final id = await db.insert('todoApp', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await SQLHelper.db();
    return db.query('todoApp', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getOneTask(int id) async {
    final db = await SQLHelper.db();
    return db.query('todoApp', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> editTask(
      int id, String title, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'title' : title,
      'description' : description,
      'createdAt' : DateTime.now().toString()
    };

    final result =
    await db.update('todoApp', data, where: 'id = ?', whereArgs: [id]);
    return result;

  }

  //DELETE
  static Future<void> deleteTask(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete('todoApp', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting the task: $err');
    }
  }

}