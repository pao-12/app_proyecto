import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Registre_screen.dart'; 
import '../utils/database_helper.dart';
import '../Models/food_entry.dart';
import '../widgets/food_entry_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  String _selectedMeal = "Desayuno"; // Comida seleccionada para filtrar
  
  // Future que contendrá la lista de FoodEntry.
  Future<List<FoodEntry>>? _foodEntriesFuture; 

  final List<String> _mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Snack'];

  @override
  void initState() {
    super.initState();
    // Inicializa la configuración de fechas
    initializeDateFormatting('es', null); 
    _loadFoodEntries(); // Carga inicial de datos (READ)
  }

  // FUNCIÓN CRUD: READ (Lectura y Filtrado)
  void _loadFoodEntries() {
    setState(() {
      // LLama al DatabaseHelper para obtener las entradas, aplicando filtros de fecha y comida.
      _foodEntriesFuture = DatabaseHelper.instance.getFoodEntries(
        date: _selectedDay,
        mealType: _selectedMeal,
      );
    });
  }

  // Gestión de la navegación para CREATE y UPDATE
  void _navigateToRegisterScreen({FoodEntry? entryToEdit, required String initialMealType}) async {
    // La navegación espera un resultado.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(
          entryToEdit: entryToEdit, // Pasa el objeto para editar (o null para crear)
          initialMealType: initialMealType,
        ),
      ),
    );

    // Si el resultado es 'true', significa que hubo una acción y se debe refrescar la lista.
    if (result == true) {
      _loadFoodEntries(); 
    }
  }

  // Abre el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
      });
      _loadFoodEntries(); // Recarga los datos con la nueva fecha (READ)
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'es');
    
    return Scaffold(
      backgroundColor: Colors.white,
      
      // BOTÓN FLOTANTE: Inicia la acción CREATE
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        onPressed: () {
          // Navega para CREAR un nuevo registro
          _navigateToRegisterScreen(initialMealType: _selectedMeal);
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
      
      body: Column(
        children: [
          // Header con filtros
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 15),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mi Diario de Alimentos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 10),
                // Selector de Fecha
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Text(dateFormatter.format(_selectedDay), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade700)),
                      const Icon(Icons.arrow_drop_down, color: Colors.green),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Chips de Filtro por Tipo de Comida
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mealTypes.length,
                    itemBuilder: (context, index) {
                      final meal = _mealTypes[index];
                      final isSelected = meal == _selectedMeal;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(meal),
                          selected: isSelected,
                          selectedColor: Colors.green.shade100,
                          backgroundColor: Colors.grey.shade100,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedMeal = meal;
                              });
                              _loadFoodEntries(); // Recarga los datos con el nuevo filtro (READ)
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // --- LISTADO DE ALIMENTOS (FutureBuilder para el READ) ---
          Expanded(
            child: FutureBuilder<List<FoodEntry>>(
              future: _foodEntriesFuture, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar alimentos: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.ramen_dining, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 15),
                        Text('¡No hay alimentos registrados!', style: TextStyle(fontSize: 18, color: Colors.grey.shade600)),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                } else {
                  // Muestra la lista de tarjetas
                  final foodEntries = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: foodEntries.length,
                    itemBuilder: (context, index) {
                      final entry = foodEntries[index];
                      return FoodEntryCard(
                        entry: entry,
                        // Acción de EDITAR: Llama a la navegación para UPDATE
                        onEdit: () {
                          _navigateToRegisterScreen(
                            entryToEdit: entry,
                            initialMealType: _selectedMeal,
                          );
                        },
                        // Acción de ELIMINAR: El callback recarga la lista (READ)
                        onDelete: _loadFoodEntries, 
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}