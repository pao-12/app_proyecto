import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'Home_screen.dart';


// Se asume que las otras pantallas de Stats y Profile existen o son placeholders.

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Índice de la pantalla actualmente seleccionada.
  int _currentIndex = 0;

  // Lista de widgets que representan las diferentes pestañas
  final List<Widget> _screens = [
    const HomeScreen(), 
    const Center(child: Text("Pantalla de Gráficos (Stats)")), 
    const Center(child: Text("Pantalla de Perfil (Profile)")), 
  ];

  // Función que se llama cuando se toca un ícono en la barra de navegación
  void _onTap(int index) {
    // La barra de navegación tiene 4 ítems (Inicio, Escaner, Notificaciones, Perfil).
    // Tu lista de pantallas (_screens) actualmente solo tiene 3. 
    // Vamos a mapear los índices de la barra (0, 1, 2, 3) a las pantallas disponibles (0, 1, 2)
    // Asumiré que el botón de "Escaner" (índice 1) y "Notificaciones" (índice 2) 
    // se dirigen temporalmente a la pantalla de "Gráficos" o "Perfil" hasta que
    // implementemos las pantallas específicas.
    // Por ahora, solo usaremos Inicio (0) y las dos placeholders (1, 2)
    // y redirigiremos Notificaciones (2) y Perfil (3) a los placeholders existentes.

    if (index == 0) {
      // Inicio
      _currentIndex = 0;
    } else if (index == 1) {
      // Escáner - Usamos un placeholder temporal
      _currentIndex = 1; 
    } else if (index == 2) {
      // Notificaciones - Usamos un placeholder temporal
      _currentIndex = 1; 
    } else if (index == 3) {
      // Perfil
      _currentIndex = 2; 
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Muestra el widget correspondiente al índice seleccionado
      body: _screens[_currentIndex], 
      
      // Barra de navegación inferior
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}