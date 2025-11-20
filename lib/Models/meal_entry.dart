class MealEntry {
  final int? entryId; // AutoIncrement
  final String userId; // Clave foránea al usuario que consumió
  final int foodId; // Clave foránea al alimento consumido
  final String mealType; // Ej: 'Desayuno', 'Almuerzo', 'Cena'
  final double portionGml; // Porción consumida en gramos (g) o mililitros (ml)
  final int consumedCalories; // Calculado (porción * calorías/100)
  final double? consumedProteinG;
  final double? consumedFatG;
  final double? consumedCarbsG;
  final String dateTime; // Fecha y hora del registro (como String, ej: ISO 8601)

  MealEntry({
    this.entryId,
    required this.userId,
    required this.foodId,
    required this.mealType,
    required this.portionGml,
    required this.consumedCalories,
    this.consumedProteinG,
    this.consumedFatG,
    this.consumedCarbsG,
    required this.dateTime,
  });

  // Convierte un objeto MealEntry a un Map (para INSERT y UPDATE)
  Map<String, dynamic> toMap() {
    return {
      'entry_id': entryId,
      'user_id': userId,
      'food_id': foodId,
      'meal_type': mealType,
      'portion_g_ml': portionGml,
      'consumed_calories': consumedCalories,
      'consumed_protein_g': consumedProteinG,
      'consumed_fat_g': consumedFatG,
      'consumed_carbs_g': consumedCarbsG,
      'date_time': dateTime,
    };
  }

  // Crea un objeto MealEntry a partir de un Map (para READ)
  factory MealEntry.fromMap(Map<String, dynamic> map) {
    return MealEntry(
      entryId: map['entry_id'] as int?,
      userId: map['user_id'] as String,
      foodId: map['food_id'] as int,
      mealType: map['meal_type'] as String,
      portionGml: map['portion_g_ml'] as double,
      consumedCalories: map['consumed_calories'] as int,
      consumedProteinG: map['consumed_protein_g'] as double?,
      consumedFatG: map['consumed_fat_g'] as double?,
      consumedCarbsG: map['consumed_carbs_g'] as double?,
      dateTime: map['date_time'] as String,
    );
  }
}