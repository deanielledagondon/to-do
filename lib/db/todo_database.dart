import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import '/model/todos.dart';

class SQLHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todos.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE todos("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            " title TEXT NOT NULL,"
            " completed INTEGER NOT NULL);");
  }

  Future<TaskModel> insertTodo(TaskModel taskModel) async {
    var dbClient = await database;
    await dbClient?.insert('todos', taskModel.toMap());
    return taskModel;
  }

  Future<List> getTodoList() async {
    var dbClient = await database;
    List<Map<String, Object?>> queryResult =
    await dbClient!.rawQuery('SELECT * FROM todos');

    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todos.db');
    databaseFactory.deleteDatabase(path);
  }

  Future<int> updateTodo(TaskModel taskModel) async {
    var dbClient = await database;
    return await dbClient!.update('todos', taskModel.toMap(),
        where: 'id = ?', whereArgs: [taskModel.id]);
  }
}
