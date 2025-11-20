import 'package:flutter/material.dart';

/// El modelo User representa la información personal y objetivos del usuario,
/// y se mapea a la tabla 'user_profile' de la base de datos.
class User {
  int? id; // El ID siempre será 1 para el usuario principal.
  String username;
  int? age; // En años
  double? heightCm; // En centímetros
  double? weightKg; // En kilogramos
  int? dailyCalorieGoal; // Objetivo calórico en kcal

  User({
    this.id,
    required this.username,
    this.age,
    this.heightCm,
    this.weightKg,
    this.dailyCalorieGoal,
  });

  // Convierte un objeto User a un Mapa (para guardarlo en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'dailyCalorieGoal': dailyCalorieGoal,
    };
  }

  // Crea un objeto User a partir de un Mapa (leído de SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      // Usamos 'as double?' y 'as int?' porque SQLite a veces almacena los números
      // como el tipo que más se ajusta.
      age: map['age'] is int ? map['age'] : (map['age'] as num?)?.toInt(),
      heightCm: map['heightCm'] is double ? map['heightCm'] : (map['heightCm'] as num?)?.toDouble(),
      weightKg: map['weightKg'] is double ? map['weightKg'] : (map['weightKg'] as num?)?.toDouble(),
      dailyCalorieGoal: map['dailyCalorieGoal'] is int ? map['dailyCalorieGoal'] : (map['dailyCalorieGoal'] as num?)?.toInt(),
    );
  }

  // Constructor para datos iniciales si no hay usuario en la DB
  factory User.initial() {
    return User(
      id: 1, // Siempre ID 1 para la única fila de perfil
      username: 'Nuevo Usuario',
      age: 25,
      heightCm: 170.0,
      weightKg: 70.0,
      dailyCalorieGoal: 2000,
    );
  }
}

  