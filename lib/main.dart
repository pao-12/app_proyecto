import 'package:contador_calorias/vista/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  runApp(const NutriTrackerApp());
}

class NutriTrackerApp extends StatelessWidget {
  const NutriTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriTracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),

      //  Rutas nombradas
      routes: {
        '/auth': (context) => const AuthScreen(),
      },

      //  Pantalla inicial
      initialRoute: '/auth',
    );
  }
}
  