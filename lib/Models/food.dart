class Food {
  final int? foodId; // AutoIncrement, por lo que es opcional al crear
  final String name;
  final String? description;
  final int caloriesPer100g;
  final double? proteinG;
  final double? fatG;
  final double? carbsG;

  Food({
    this.foodId,
    required this.name,
    this.description,
    required this.caloriesPer100g,
    this.proteinG,
    this.fatG,
    this.carbsG,
  });

  // Convierte un objeto Food a un Map (para INSERT y UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'food_id': foodId,
      'name': name,
      'description': description,
      'calories_per_100g': caloriesPer100g,
      'protein_g': proteinG,
      'fat_g': fatG,
      'carbs_g': carbsG,
    };
  }

  // Crea un objeto Food a partir de un Map (para READ)
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      foodId: map['food_id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      caloriesPer100g: map['calories_per_100g'] as int,
      // Los campos REAL se leen como double en Dart/SQLite
      proteinG: map['protein_g'] as double?,
      fatG: map['fat_g'] as double?,
      carbsG: map['carbs_g'] as double?,
    );
  }
}