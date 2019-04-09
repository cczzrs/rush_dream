import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

/// 数据库管理
class SqlManager {
  static const _VERSION = 1;
  static const _NAME = "fmwl.db";
  static Database _database;

  /// 初始化
  static init() async {
    // 数据库连接
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + (Platform.isIOS ? "/" : "") + _NAME;
    _database = await openDatabase(path, version: _VERSION, onCreate: (Database db, int version) async {
      // 查询数据库表是否存在
      var res = await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = 'fmwl_main'");
      if (res == null || res.length < 1) {
        // 新建数据库表
        await db.execute('''create table fmwl_main(
                          id integer primary key autoincrement,
                          code text not null,
                          user text,
                          status text not null,
                          created text not null,
                          updated text
                        ''');
//      await db.execute("CREATE TABLE fmwl_main (ID INTEGER PRIMARY KEY, name TEXT, value INTEGER, status REAL)");
      }
    });
  }

  /// 获取 - 数据库连接对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  /// 关闭 - 数据库连接对象
  static close() {
    _database?.close();
    _database = null;
  }
}
