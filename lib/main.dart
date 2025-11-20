import 'package:contador_calorias/vista/main_screen.dart';
import 'package:flutter/material.dart';


void main() {
  // Asegura que las funciones de Flutter se han inicializado antes de la app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NutriTrackerApp());
}

class NutriTrackerApp extends StatelessWidget {
  const NutriTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Desactiva la banda de debug en la esquina
      debugShowCheckedModeBanner: false,
      title: 'NutriTracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      // La aplicación inicia en MainScreen, que contiene la navegación
      home: const MainScreen(),
    );
  }
}