import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import '../Models/food_entry.dart';
import '../Models/user.dart';

class DatabaseHelper {
  static const _databaseName = "calories_app.db";
  static const _databaseVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create a single unified table for food entries and a small user profile table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        mealType TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        calories INTEGER NOT NULL,
        carbs REAL NOT NULL,
        fats REAL NOT NULL,
        proteins REAL NOT NULL,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        age INTEGER,
        heightCm REAL,
        weightKg REAL,
        dailyCalorieGoal INTEGER
      )
    ''');
  }

  // -------------------------
  // FoodEntry CRUD
  // -------------------------

  Future<int> insertFoodEntry(FoodEntry entry) async {
    final db = await database;
    return await db.insert('food_entries', entry.toMap());
  }

  Future<List<FoodEntry>> getFoodEntries({DateTime? date, String? mealType}) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;

    if (date != null || mealType != null) {
      final parts = <String>[];
      final args = <dynamic>[];
      if (date != null) {
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        parts.add('date = ?');
        args.add(dateStr);
      }
      if (mealType != null) {
        parts.add('mealType = ?');
        args.add(mealType);
      }
      where = parts.join(' AND ');
      whereArgs = args;
    }

    final maps = await db.query(
      'food_entries',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'id DESC',
    );

    return maps.map((m) => FoodEntry.fromMap(m)).toList();
  }

  Future<int> updateFoodEntry(FoodEntry entry) async {
    final db = await database;
    if (entry.id == null) return 0;
    return await db.update(
      'food_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteFoodEntry(int id) async {
    final db = await database;
    return await db.delete(
      'food_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // -------------------------
  // User profile helpers
  // -------------------------

  Future<User?> getPrimaryUser() async {
    final db = await database;
    final maps = await db.query('user_profile', where: 'id = ?', whereArgs: [1], limit: 1);
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<int> insertOrUpdateUser(User user) async {
    final db = await database;
    // enforce id = 1 when inserting
    final map = user.toMap();
    if (user.id == null) map['id'] = 1;
    return await db.insert('user_profile', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
