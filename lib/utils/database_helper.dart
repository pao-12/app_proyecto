import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/food_entry.dart';
import '../Models/user.dart'; // Importa User (ruta con mayúscula consistente con carpeta `Models`)
import 'package:intl/intl.dart';

/// La clase DatabaseHelper maneja todas las operaciones CRUD (Crear, Leer, Actualizar, Eliminar)
/// con la base de datos SQLite. Se implementa como un Singleton.
class DatabaseHelper {
  // ----------------------------------------------------
  // 1. SINGLETON SETUP
  // ----------------------------------------------------
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  // Nombres de las tablas
  static const String foodEntriesTable = 'food_entries';
  static const String userProfileTable = 'user_profile';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // ----------------------------------------------------
  // 2. INICIALIZACIÓN DE LA DB
  // ----------------------------------------------------
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'nutritracker_db.db'); 
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, 
    );
  }

  /// Método para crear las tablas (se llama solo en la primera instalación).
  void _onCreate(Database db, int version) async {
    // 1. Tabla de Registros de Alimentos
    await db.execute('''
      CREATE TABLE $foodEntriesTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        mealType TEXT,
        name TEXT,
        description TEXT,
        calories INTEGER,
        carbs REAL,
        fats REAL,
        proteins REAL
      )
    ''');

    // 2. Tabla de Perfil de Usuario (Solo tendrá una fila con ID=1)
    await db.execute('''
      CREATE TABLE $userProfileTable(
        id INTEGER PRIMARY KEY,
        username TEXT,
        age INTEGER,
        heightCm REAL,
        weightKg REAL,
        dailyCalorieGoal INTEGER
      )
    ''');
    
    // Inserta un usuario inicial al crear la base de datos
    await db.insert(userProfileTable, User.initial().toMap());
  }

  static DatabaseHelper get instance => _instance;

  // ----------------------------------------------------
  // 3. OPERACIONES CRUD para FOOD ENTRIES
  // ----------------------------------------------------
  Future<int> insertFoodEntry(FoodEntry entry) async {
    final db = await database;
    return await db.insert(foodEntriesTable, entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FoodEntry>> getFoodEntries({required DateTime date, required String mealType}) async {
    final db = await database;
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(date);

    final List<Map<String, dynamic>> maps = await db.query(
      foodEntriesTable,
      where: 'date = ? AND mealType = ?',
      whereArgs: [formattedDate, mealType],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => FoodEntry.fromMap(maps[i]));
  }

  Future<int> updateFoodEntry(FoodEntry entry) async {
    final db = await database;
    return await db.update(
      foodEntriesTable,
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteFoodEntry(int id) async {
    final db = await database;
    return await db.delete(
      foodEntriesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ----------------------------------------------------
  // 4. OPERACIONES CRUD para USER PROFILE
  // ----------------------------------------------------

  /// R - READ: Obtiene el único registro de usuario (ID=1).
  Future<User?> getPrimaryUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      userProfileTable,
      where: 'id = ?',
      whereArgs: [1], // Siempre buscamos el ID 1
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      // Si está vacía, insertamos la inicial para el futuro
      final initialUser = User.initial();
      await insertOrUpdateUser(initialUser);
      return initialUser; 
    }
  }

  /// C/U - CREATE/UPDATE: Inserta o actualiza el usuario principal (ID=1).
  Future<int> insertOrUpdateUser(User user) async {
    final db = await database;
    
    // Intentamos actualizar
    final rowsAffected = await db.update(
      userProfileTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [1],
    );

    // Si no se actualizó ninguna fila (porque no existía), la insertamos
    if (rowsAffected == 0) {
      return await db.insert(
        userProfileTable,
        user.toMap(), // Usamos el mapa del usuario proporcionado, no User.initial()
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return rowsAffected;
  }
}