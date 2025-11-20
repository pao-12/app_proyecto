import 'package:flutter/material.dart';

// Convertido a StatefulWidget para manejar correctamente los TextEditingController
class FoodFormScreen extends StatefulWidget {
  final String mealType;
  // Opcionalmente podrías pasar un path de imagen real si tuvieras una cámara implementada
  final String imagePlaceholder; 

  const FoodFormScreen({
    super.key,
    required this.mealType,
    this.imagePlaceholder = 'assets/image/food_placeholder.png', // Un placeholder para la imagen capturada
  });

  @override
  State<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
  // Controladores para los campos de texto: ahora son parte del estado.
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Inicialización de los controladores en initState
    _nameController = TextEditingController(text: 'Manzana Roja Fresca');
    _descriptionController = TextEditingController(text: 'Alimento rico en fibra y vitaminas. Escaneado manualmente.');
  }

  @override
  void dispose() {
    // Es crucial liberar los recursos de los controladores cuando el widget se destruye
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    final foodName = _nameController.text;
    final foodDescription = _descriptionController.text;
    
    // TODO: Lógica para guardar el alimento en Firestore o la base de datos local
    
    // Simular el guardado y volver atrás
    print('Guardando: Nombre=$foodName, Descripción=$foodDescription');
    Navigator.pop(context);
  }

  void _onCancel(BuildContext context) {
    // Simplemente vuelve atrás
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo de la pantalla con un color personalizado (similar a registre_screen)
      backgroundColor: const Color(0xFFEAF3E0), 

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ENCABEZADO CON FLECHA DE REGRESO ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  // Botón para volver atrás
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                    color: Colors.grey.shade900,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Registrar ${widget.mealType}", // Usamos widget.mealType para acceder a la propiedad
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // --- CONTENEDOR PRINCIPAL BLANCO ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- IMAGEN CAPTURADA / PLACEHOLDER ---
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 250,
                            height: 250,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.fastfood,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),

                      // --- CAMPO: Nombre del Platillo ---
                      const Text(
                        'Nombre del Platillo/Alimento',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Ej: Ensalada César, vaso de agua',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // --- CAMPO: Descripción (Opcional) ---
                      const Text(
                        'Descripción (Detalles del registro)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Añade detalles como porciones, ingredientes extra, etc.',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      
                      const SizedBox(height: 40),

                      // --- BOTONES DE ACCIÓN ---
                      Row(
                        children: [
                          // Botón de Cancelar
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _onCancel(context), // Llama a la función de cancelar
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade700,
                                side: BorderSide(color: Colors.red.shade700, width: 2),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 20),
                          
                          // Botón de Guardar
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _onSave(context), // Llama a la función de guardar
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600, // Color verde
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Guardar',
                                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}