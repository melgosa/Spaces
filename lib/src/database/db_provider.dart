import 'dart:io';

import 'package:monitor_ia/src/models/push_notification_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    //Path de donde almacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'B2W.db');

    //print(path);

    //Crear base de datos
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('''
        CREATE TABLE Notificacion(
          id INTEGER PRIMARY KEY,
          title TEXT,
          contenido TEXT,
          prioridad TEXT,
          fechaDeEnvio TEXT,
          fechaDeEntrega TEXT
        )
      ''');

        });
  }

  Future<int> insertNotification(PushNotification notification) async {
    final db = await database;
    final res = await db.insert('Notificacion', notification.toJson());
    return res;
  }

  Future<List<PushNotification>> getListOfAllNotifications() async {
    final db = await database;
    final res = await db.query('Notificacion', orderBy: "id desc");

    return res.isNotEmpty
        ? res.map((notificacion) => PushNotification.fromJson(notificacion)).toList()
        : [];
  }

  Future<List<PushNotification>> getLastNotification() async {
    final db = await database;
    final res = await db.query('Notificacion', orderBy: "id desc", limit: 1);

    return res.isNotEmpty
        ? res.map((notificacion) => PushNotification.fromJson(notificacion)).toList()
        : [];
  }

  Future<int> deleteAllNotifications() async {
    final db = await database;
    final res = await db.delete('Notificacion');

    return res;
  }

  Future<int> deleteNotificationById(int idNotification) async {
    final db = await database;
    final res = await db.delete('Notificacion', where: 'id = ?', whereArgs: [idNotification]);

    return res;
  }

}
