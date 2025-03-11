import 'package:floor/floor.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Web support
import 'todo.dart';
import 'ToDoItemDao.dart';


part 'database.g.dart';

@Database(version: 1, entities: [Todo])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
}