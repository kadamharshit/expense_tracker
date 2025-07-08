import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expense_tracker.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        shop TEXT,
        category TEXT,
        items TEXT,
        total REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE budget(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        amount REAL,
        mode TEXT)
     ''');
  }

  Future<int> insertExpense(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('expenses', data);
  }
Future<List<Map<String, dynamic>>> getBudget() async {
  final db = await instance.database;
  return await db.query('budget', orderBy: 'date DESC');
}
  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await instance.database;
    return await db.query('expenses', orderBy: 'date DESC');
  }
  Future<int> insertBudget(Map<String, dynamic>data) async {
    final db = await instance.database;
    return await db.insert('budget', data);
  }
  Future<int> updateExpense(int id, Map<String, dynamic> updatedData) async {
  final db = await instance.database;
  return await db.update('expenses', updatedData, where: 'id = ?', whereArgs: [id]);
}

Future<int> deleteExpense(int id) async {
  final db = await instance.database;
  return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
}


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
