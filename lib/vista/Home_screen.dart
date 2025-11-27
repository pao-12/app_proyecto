import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'registre_screen.dart'; 
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
  String _selectedMeal = "Desayuno";
  Future<List<FoodEntry>>? _foodEntriesFuture; 
  final List<String> _mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Bebidas'];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es', null); 
    _loadFoodEntries();
  }

  void _loadFoodEntries() {
    setState(() {
      _foodEntriesFuture = DatabaseHelper.instance.getFoodEntries(
        date: _selectedDay,
        mealType: _selectedMeal,
      );
    });
  }

  void _navigateToRegisterScreen({FoodEntry? entryToEdit, required String initialMealType}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(
          entryToEdit: entryToEdit,
          initialMealType: initialMealType,
        ),
      ),
    );

    if (result == true) {
      _loadFoodEntries(); 
    }
  }

  /// ✅ CALENDARIO COMO VENTANA EMERGENTE CENTRADA
  void _showCalendarModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Encabezado con flecha
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Seleccionar fecha',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              TableCalendar(
                locale: 'es_ES',
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                focusedDay: _selectedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                  _loadFoodEntries();
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'es');
    
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        onPressed: () {
          _navigateToRegisterScreen(initialMealType: _selectedMeal);
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 15),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mi Diario de Alimentos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 10),

                /// Al tocar aquí se abre el dialog centrado
                GestureDetector(
                  onTap: _showCalendarModal,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Text(
                        dateFormatter.format(_selectedDay), 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade700)
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.green),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
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
                              _loadFoodEntries();
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

          Expanded(
            child: FutureBuilder<List<FoodEntry>>(
              future: _foodEntriesFuture, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar alimentos: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('¡No hay alimentos registrados!'));
                } else {
                  final foodEntries = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: foodEntries.length,
                    itemBuilder: (context, index) {
                      final entry = foodEntries[index];
                      return FoodEntryCard(
                        entry: entry,
                        onEdit: () {
                          _navigateToRegisterScreen(
                            entryToEdit: entry, 
                            initialMealType: _selectedMeal
                          );
                        },
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
