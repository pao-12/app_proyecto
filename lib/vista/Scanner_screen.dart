import 'package:flutter/material.dart';
import 'food_form_screen.dart'; // Importamos el formulario de ingreso de datos

class ScannerScreen extends StatelessWidget {
  // Parámetro opcional para saber si es un 'Alimento' o 'Bebida', por ejemplo.
  final String mealType; 
  const ScannerScreen({super.key, this.mealType = 'Alimento'});

  /// Función para manejar la navegación al formulario.
  /// En una aplicación real, aquí se procesaría el resultado del escaneo
  /// antes de navegar.
  void _simulateCaptureAndNavigate(BuildContext context) {
    // Simula que la captura o escaneo fue exitoso
    Navigator.push(
      context,
      MaterialPageRoute(
        // Navega al formulario, pasando el tipo de elemento
        builder: (context) => FoodFormScreen(mealType: mealType), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro para simular la cámara
      body: SafeArea(
        child: Column(
          children: [
            // --- ENCABEZADO CON FLECHA DE REGRESO ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 25),
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Escáner de $mealType', // Título dinámico
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // --- ÁREA DE LA CÁMARA (Provisional) ---
            Expanded(
              child: Container(
                color: Colors.black,
                child: Center(
                  // Simulación del visor de la cámara
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white54, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'Apunte al código de barras',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // --- BARRA INFERIOR DE ACCIONES ---
            Container(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Botón para ingresar manualmente
                  TextButton.icon(
                    onPressed: () {
                      // Simula la navegación manual al formulario
                      _simulateCaptureAndNavigate(context);
                    },
                    icon: const Icon(Icons.keyboard, color: Colors.white),
                    label: const Text('Manual', style: TextStyle(color: Colors.white)),
                  ),
                  
                  // Botón de captura/acción
                  GestureDetector(
                    onTap: () => _simulateCaptureAndNavigate(context), // Llama a la función de navegación
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade700, width: 5),
                      ),
                    ),
                  ),
                  
                  // Botón de linterna
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implementar la lógica para activar/desactivar la linterna
                    },
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    label: const Text('Flash', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}