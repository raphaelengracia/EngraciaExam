import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';
import 'dart:io' as io;

class DBhandler {
  static Database? _db;

  Future<Database?> get db async {
    if(_db != null){
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase()async{
    io.Directory docdirect = await getApplicationDocumentsDirectory();
    String path = join(docdirect.path, 'Todo.db');
    var db = await openDatabase(path,version: 1, onCreate: _createdb);
    return db;
  }

  _createdb(Database db, int version)async{
    await db.execute(
      "CREATE TABLE TASK(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL)",
    );
  }
  //insert data
  Future<TodoMod> insert(TodoMod todoMod) async{
    var dbClient = await db;
    await dbClient?.insert('task', todoMod.toMap());
    return todoMod;
  }

  Future<List<TodoMod>> getDataList() async{
    await db;
    final List<Map<String, Object?>> QueryRes = await _db!.rawQuery("SELECT * FROM task");
    return QueryRes.map((e) => TodoMod.fromMap(e)).toList();
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient!.delete('task',where: 'id = ?', whereArgs: [id]);
  }
  Future<int> update (TodoMod todoMod) async{
    var dbClient = await db;
    return await dbClient!.update('task', todoMod.toMap(),where:'id = ?', whereArgs: [todoMod.id]);
  }
}