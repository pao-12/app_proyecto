import 'dart:convert';
import 'package:contador_calorias/Models/food_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  static const String _entriesKey = 'foodEntries';

  // Leer todas las entradas
  Future<List<FoodEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_entriesKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => FoodEntry.fromJson(json)).toList();
    } catch (e) {
      // Manejo de error si los datos guardados están corruptos
      print('Error al decodificar las entradas de comida: $e');
      return [];
    }
  }

  // Guardar (Crear/Actualizar) una entrada
  Future<void> saveEntry(FoodEntry newEntry) async {
    final entries = await getEntries();
    final prefs = await SharedPreferences.getInstance();

    // Buscar si ya existe una entrada con el mismo ID para actualizar (U)
    int existingIndex = entries.indexWhere((e) => e.id == newEntry.id);

    if (existingIndex != -1) {
      // Actualizar la entrada existente
      entries[existingIndex] = newEntry;
    } else {
      // Crear nueva entrada (C)
      entries.add(newEntry);
    }

    // Convertir la lista de objetos a una lista de JSONs y luego a String
    final jsonList = entries.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    await prefs.setString(_entriesKey, jsonString);
  }

  // Eliminar (Delete) una entrada por ID
  Future<void> deleteEntry(String id) async {
    final entries = await getEntries();
    final prefs = await SharedPreferences.getInstance();

    // Eliminar la entrada con el ID coincidente
    entries.removeWhere((e) => e.id == id);

    // Volver a guardar la lista actualizada
    final jsonList = entries.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    await prefs.setString(_entriesKey, jsonString);
  }
}