import 'dart:async';
import 'dart:convert';
import 'package:rush_dream/common/db/db_manager.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

/// fmwl_main 表操作
class MainDao {
//    id integer primary key autoincrement,
//    code text not null,
//    user text,
//    status text not null,
//    created text not null,
//    updated text
    static const String tableName = "fmwl_main";
    static const Map fmwl_main = {
        "code": "",
        "user": "",
        "status": "",
        "created": "",
        "updated": "",
    };
    
    /// 依据该时间格式划分数据的更新周期 （"yyyy-MM-dd" 当前为每天一条数据）
    static const String dateFormatStr = "yyyy-MM-dd";
    /// 标准时间格式
    static const String dateTimeFormatStr = "yyyy-MM-dd HH:mm:ss";
    
    /// 获取数据库连接
    Future<Database> getDB() async {
        return await SqlManager.getCurrentDatabase();
    }
    
    /// 返回数据 MD5 密文
    String getDateMD5(String data) {
        var content = new Utf8Encoder().convert(data);
        var digest = md5.convert(content);
        // 这里其实就是 digest.toString()
        return hex.encode(digest.bytes);
    }
    
    /// 返回指定时间格式 - 默认为标准时间格式
    String getDateStr({String dateFmtStr=dateTimeFormatStr}) {
        return new DateFormat(dateFmtStr).format(new DateTime.now());
    }
    
    /// code 为需要同步的数据进行 MD5 获取密文
    Map setCode(Map data) {
        Map VData = {};
        VData["user"] = data["user"];
        VData["status"] = data["status"];
        VData["created"] = data["created"];
        data["code"] = getDateMD5(VData.toString());
        return data;
    }
    
    /// 返回一个空的 fmwl_main 数据集
    Map getMap() {
        var data = fmwl_main;
        data["created"] = getDateStr(dateFmtStr:dateFormatStr);
        data["updated"] = getDateStr();// 更新更新时间
        return setCode(data);
    }
    
    /// 判断是否能更新当前一条的数据
    bool isExists(String dateStr, {bool insert=true}) {
        // 查询是否存在该条数据，如果不存在创建一条，返回 true
        Database db = getDB() as Database;
        dynamic count = db.rawQuery("select count(*) from $tableName where created='$dateStr'");
        if (count != null && count[0]['count(*)'] > 0) {
            return true;
        } else {
            if(insert){
                db.insert(tableName, getMap()).then((ret) {
                    return ret > 0;
                });
            }
        }
        return false;
    }
    
    /// 保存或更新数据 - 根据时间查询是那一条，默认当前一条
    bool saveUp(Map<String, dynamic> data, {String dateStr}) {
        dateStr ??= getDateStr(dateFmtStr:dateFormatStr);
        if (isExists(dateStr)) {
            data["updated"] = getDateStr();// 更新更新时间
            data = setCode(data);// 更新同步数据密文
            Database db = getDB() as Database;
            db.update(tableName, data, where: " created = ? ", whereArgs: [dateStr]).then((ret) {
                return ret > 0;
            });
        }
        return false;
    }
    
    /// 查询信息
    List query(List<String> columns, {String dateStr}) {
        if (dateStr==null) {
            Database db = getDB() as Database;
            db.query(tableName, columns:columns, where: " status = ? ", whereArgs: ["1"], orderBy:"created").then((ret) {
                return ret;
            });
        }else{
            if(isExists(dateStr, insert: false)){
                Database db = getDB() as Database;
                db.query(tableName, columns:columns, where: " created = ? AND status = ? ", whereArgs: [dateStr,"1"], orderBy:"created").then((ret) {
                    return ret;
                });
            }
        }
        return [];
    }
}
