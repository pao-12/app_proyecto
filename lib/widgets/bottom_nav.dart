import 'package:flutter/material.dart';

/// Widget personalizado para la barra de navegación inferior
/// que se muestra en la parte baja de la app (BottomNavigationBar).
/// Permite cambiar entre las distintas pantallas principales
/// como Inicio, Escaner, Notificaciones y Perfil.
class BottomNavBar extends StatelessWidget {
  /// Índice actual que indica qué ítem (pestaña) está seleccionado.
  final int currentIndex;

  /// Función que se ejecuta cuando el usuario toca un ítem.
  /// Recibe el índice del botón presionado.
  final Function(int) onTap;

  /// Constructor del widget, requiere los parámetros anteriores.
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // Índice actual del botón seleccionado.
      currentIndex: currentIndex,

      // Función que maneja los toques del usuario.
      // Cuando el usuario presiona un ícono, se llama a onTap con el índice.
      onTap: onTap,

      // Fija los botones en su posición (no se desplazan ni se reducen).
      type: BottomNavigationBarType.fixed,

      // Color de los íconos y textos seleccionados.
      selectedItemColor: Colors.green,

      // Color de los íconos y textos no seleccionados.
      unselectedItemColor: Colors.grey,

      // Tamaño de los íconos.
      iconSize: 28,

      // Elementos que se muestran en la barra de navegación.
      items: const [
        // Botón "Inicio"
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),

        // Botón "Escanear" (para registrar alimentos o bebidas)
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Escaner',
        ),

        // Botón "Notificaciones"
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_none),
          label: 'Notificaciones',
        ),

        // Botón "Perfil"
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }
}