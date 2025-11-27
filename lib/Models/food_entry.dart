// Modelo independiente: no necesita importar Flutter directamente.

/// Define los tipos de comida disponibles.
enum MealType { desayuno, almuerzo, cena, snack }

/// El modelo FoodEntry representa un registro de comida en el diario.
class FoodEntry {
  // Usamos int? para el ID de SQLite.
  // Es nulo cuando se está creando la entrada por primera vez.
  int? id; 
  
  // Usamos String para la fecha en formato 'yyyy-MM-dd' para SQLite.
  final String date; 
  final String mealType; // Debe ser uno de los nombres del enum: 'desayuno', 'almuerzo', etc.
  final String name;
  final String? description;
  final String? imagePath;
  final int calories;
  final double carbs;
  final double fats;
  final double proteins;

  FoodEntry({
    this.id,
    required this.date,
    required this.mealType,
    required this.name,
    this.description,
    this.imagePath,
    required this.calories,
    required this.carbs,
    required this.fats,
    required this.proteins,
  });

  // ----------------------------------------------------
  // Mapeo para SQLite (Usado por DatabaseHelper)
  // ----------------------------------------------------

  /// Convierte un objeto FoodEntry a un Mapa (para guardarlo en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'mealType': mealType,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'calories': calories,
      'carbs': carbs,
      'fats': fats,
      'proteins': proteins,
    };
  }

  /// Crea un objeto FoodEntry a partir de un Mapa (leído de SQLite)
  factory FoodEntry.fromMap(Map<String, dynamic> map) {
    // Es crucial manejar la conversión de tipos aquí ya que SQLite puede almacenar
    // números reales como num o double, y los enteros como num o int.
    return FoodEntry(
      id: map['id'] as int,
      date: map['date'] as String,
      mealType: map['mealType'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      imagePath: map['imagePath'] as String?,
      calories: map['calories'] as int,
      // Aseguramos la conversión a double, que es el tipo esperado en Dart.
      carbs: (map['carbs'] as num).toDouble(),
      fats: (map['fats'] as num).toDouble(),
      proteins: (map['proteins'] as num).toDouble(),
    );
  }

  // ----------------------------------------------------
  // Mapeo para JSON (si fuera necesario fuera de la DB)
  // ----------------------------------------------------
  
  // Se mantienen para compatibilidad si alguna parte de tu app usaba serialización JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'mealType': mealType,
    'name': name,
    'description': description,
    'calories': calories,
    'carbs': carbs,
    'fats': fats,
    'proteins': proteins,
  };

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'] as int?,
      date: json['date'] as String,
      mealType: json['mealType'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imagePath: json['imagePath'] as String?,
      calories: json['calories'] as int,
      carbs: (json['carbs'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      proteins: (json['proteins'] as num).toDouble(),
    );
  }
}