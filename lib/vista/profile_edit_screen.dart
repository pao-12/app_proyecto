import 'package:flutter/material.dart';
import '../Models/user.dart';
import '../utils/database_helper.dart';

class ProfileEditScreen extends StatefulWidget {
  final User user;

  const ProfileEditScreen({super.key, required this.user});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  // Controladores para el formulario
  late TextEditingController _usernameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _calorieGoalController;
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los datos del usuario
    _usernameController = TextEditingController(text: widget.user.username);
    _ageController = TextEditingController(text: widget.user.age?.toString() ?? '');
    _heightController = TextEditingController(text: widget.user.heightCm?.toString() ?? '');
    _weightController = TextEditingController(text: widget.user.weightKg?.toString() ?? '');
    _calorieGoalController = TextEditingController(text: widget.user.dailyCalorieGoal?.toString() ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _calorieGoalController.dispose();
    super.dispose();
  }

  // Función para guardar los cambios (Operación UPDATE)
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        id: widget.user.id ?? 1, // Mantiene el id existente o usa 1 por defecto
        username: _usernameController.text,
        age: int.tryParse(_ageController.text),
        heightCm: double.tryParse(_heightController.text),
        weightKg: double.tryParse(_weightController.text),
        dailyCalorieGoal: int.tryParse(_calorieGoalController.text),
      );

      // Llama a la función de la base de datos para actualizar
      await DatabaseHelper.instance.insertOrUpdateUser(updatedUser);
      
      // Regresa a la pantalla anterior, indicando que hubo una actualización (true)
      if (mounted) {
        Navigator.pop(context, true); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green, size: 30),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Username
              _buildTextField(
                controller: _usernameController,
                label: 'Nombre de Usuario',
                icon: Icons.person,
                keyboardType: TextInputType.text,
                validator: (value) => value == null || value.isEmpty ? 'El nombre es requerido' : null,
              ),
              const SizedBox(height: 15),
              // Edad
              _buildTextField(
                controller: _ageController,
                label: 'Edad (años)',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              // Altura
              _buildTextField(
                controller: _heightController,
                label: 'Altura (cm)',
                icon: Icons.height,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              // Peso
              _buildTextField(
                controller: _weightController,
                label: 'Peso (kg)',
                icon: Icons.scale,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              // Objetivo Calórico
              _buildTextField(
                controller: _calorieGoalController,
                label: 'Objetivo Calórico Diario (kcal)',
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              // Botón de Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Guardar Cambios', style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper para construir los campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }
}