import 'dart:async';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:to_do_sample/model/todos.dart';


class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE Todos(
          userId INTEGER NOT NULL,
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          completed INTEGER NOT NULL)"""
    );
  }


  static Future<sql.Database> db() async {
    return sql.openDatabase(
        'Todos.db',
        version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        }
    );
  }

  static Future<int> createItem(String? userID, String? title, String? completed) async {
    final db = await SQLHelper.db();

    final data = {'userID': userID, 'title': title, 'completed': completed};
    final id = await db.insert(
        'Todos.db',
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('Todos.db', orderBy: 'userID');
  }


  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();

    return db.query('Todos.db', where: 'userID = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String userID, String title, String completed) async {

    final db = await SQLHelper.db();

    final data = {
      'userID': userID,
      'id': id,
      'title': title,
      'completed': completed,
    };

    final result = await db.update('Todos.db', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItems(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("Todos.db",  where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint('Something went wrong when deleting an item: $err');
    }
  }

}