import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import '../Models/food_entry.dart';
import '../utils/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  // Objeto opcional: si es nulo, es CREATE. Si tiene valor, es UPDATE.
  final FoodEntry? entryToEdit; 
  final String initialMealType; 

  const RegisterScreen({
    super.key,
    this.entryToEdit,
    this.initialMealType = 'Desayuno',
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatsController;
  late final TextEditingController _proteinsController;
  late String _selectedMealType;
  
  final List<String> _mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Snack'];
  
  // Getter simple para saber el modo de la pantalla
  bool get isEditing => widget.entryToEdit != null;

  @override
  void initState() {
    super.initState();
    // Inicialización de controladores basada en el modo (Crear o Editar)
    if (isEditing) {
      final entry = widget.entryToEdit!;
      _nameController = TextEditingController(text: entry.name);
      _descriptionController = TextEditingController(text: entry.description);
      _caloriesController = TextEditingController(text: entry.calories.toString());
      _carbsController = TextEditingController(text: entry.carbs.toString());
      _fatsController = TextEditingController(text: entry.fats.toString());
      _proteinsController = TextEditingController(text: entry.proteins.toString());
      _selectedMealType = entry.mealType;
    } else {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _caloriesController = TextEditingController();
      _carbsController = TextEditingController();
      _fatsController = TextEditingController();
      _proteinsController = TextEditingController();
      _selectedMealType = widget.initialMealType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _proteinsController.dispose();
    super.dispose();
  }

  // --- FUNCIÓN CRUD: CREATE/UPDATE ---
  void _saveEntry() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // 1. Construir el objeto FoodEntry
    FoodEntry entry = FoodEntry(
      id: isEditing ? widget.entryToEdit!.id : null,
      mealType: _selectedMealType,
      name: _nameController.text,
      description: _descriptionController.text,
      // El modelo usa fecha como String en formato 'yyyy-MM-dd'
      date: isEditing
          ? widget.entryToEdit!.date
          : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      calories: int.tryParse(_caloriesController.text) ?? 0,
      carbs: double.tryParse(_carbsController.text) ?? 0.0,
      fats: double.tryParse(_fatsController.text) ?? 0.0,
      proteins: double.tryParse(_proteinsController.text) ?? 0.0,
    );

    try {
      if (isEditing) {
        // Llama a la operación UPDATE
        await DatabaseHelper.instance.updateFoodEntry(entry);
      } else {
        // Llama a la operación CREATE
        await DatabaseHelper.instance.insertFoodEntry(entry);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alimento ${isEditing ? 'actualizado' : 'registrado'} con éxito!')),
      );

      // Regresa a la pantalla anterior, pasando 'true' para indicar que se debe refrescar
      Navigator.pop(context, true); 

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar datos: $e')),
      );
    }
  }

  // Muestra el diálogo de confirmación (llamado antes de _saveEntry)
  Future<void> _showSaveConfirmationDialog() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final String action = isEditing ? 'Editar' : 'Registrar';

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar $action'),
          content: Text('¿Estás seguro de que deseas $action este alimento?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Aceptar', style: TextStyle(color: Colors.green.shade700)),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      _saveEntry(); // Ejecuta la función de guardado
    }
  }

  // Widget auxiliar para construir campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Helper para campos numéricos (calorías, macros)
  Widget _buildNumberField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Alimento' : 'Registrar Alimento', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de Comida (Dropdown)
              const Text('Tipo de Comida', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
                value: _selectedMealType,
                items: _mealTypes.map((String meal) {
                  return DropdownMenuItem<String>(value: meal, child: Text(meal));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMealType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Campo: Nombre del Alimento
              _buildTextField(
                controller: _nameController,
                labelText: 'Nombre del Plato o Alimento',
                validator: (value) => value!.isEmpty ? 'El nombre es obligatorio.' : null,
              ),

              // Campo: Descripción/Porción
              _buildTextField(
                controller: _descriptionController,
                labelText: 'Descripción / Porción (Ej: 1 taza, 150g)',
                validator: (value) => value!.isEmpty ? 'La descripción es obligatoria.' : null,
                maxLines: 3,
              ),
              // Campos numéricos: calorías y macros
              _buildNumberField(
                controller: _caloriesController,
                labelText: 'Calorías (kcal)',
                validator: (value) => (value == null || value.isEmpty) ? 'Las calorías son obligatorias.' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      controller: _carbsController,
                      labelText: 'Carbohidratos (g)',
                      validator: (value) => (value == null || value.isEmpty) ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNumberField(
                      controller: _fatsController,
                      labelText: 'Grasas (g)',
                      validator: (value) => (value == null || value.isEmpty) ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      controller: _proteinsController,
                      labelText: 'Proteínas (g)',
                      validator: (value) => (value == null || value.isEmpty) ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),

              // BOTÓN DE GUARDAR/ACTUALIZAR
              ElevatedButton(
                onPressed: _showSaveConfirmationDialog, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.blue.shade600 : Colors.green.shade600,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  isEditing ? 'Actualizar Alimento' : 'Registrar Alimento',
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}