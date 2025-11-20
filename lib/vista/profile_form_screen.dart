import 'package:flutter/material.dart';

// Definición del widget principal de la pantalla del formulario de perfil.
class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  // --- Controladores para los campos de texto ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // --- Variables para los campos seleccionables ---
  String? _gender; // Género seleccionado (Hombre, Mujer, Otro)
  String? _activityLevel; // Nivel de actividad física

  // Lista de opciones para el género
  final List<String> _genderOptions = ['Hombre', 'Mujer', 'Otro'];

  // Lista de opciones para el nivel de actividad física
  final List<String> _activityLevels = [
    'Sedentario (poco o ningún ejercicio)',
    'Actividad ligera (ejercicio ligero 1-3 días/semana)',
    'Actividad moderada (ejercicio moderado 3-5 días/semana)',
    'Actividad alta (ejercicio intenso 6-7 días/semana)',
    'Actividad muy alta (ejercicio muy intenso, trabajo físico)'
  ];

  // Identificador global para el formulario, necesario para la validación.
  final _formKey = GlobalKey<FormState>();

  // Función que se llama al presionar el botón de "Guardar Perfil"
  void _saveProfile() {
    // Valida todos los campos del formulario.
    if (_formKey.currentState!.validate()) {
      // Verifica que los campos de selección (género y actividad) no estén vacíos.
      if (_gender == null || _activityLevel == null) {
        // Muestra un SnackBar si faltan selecciones.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Por favor, selecciona tu género y nivel de actividad.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Si la validación es exitosa, se pueden procesar los datos.
      // Aquí iría la lógica para guardar en la base de datos (Firestore o SQLite).
      
      final profileData = {
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text),
        'gender': _gender,
        'height_cm': double.tryParse(_heightController.text),
        'weight_kg': double.tryParse(_weightController.text),
        'activity_level': _activityLevel,
      };

      // Simulación de navegación después de guardar
      // En una aplicación real, probablemente navegarías a la pantalla principal (Home).
      print('Datos del perfil a guardar: $profileData');
      
      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil de ${_nameController.text} guardado con éxito!'),
          backgroundColor: Colors.green,
        ),
      );

      // Aquí podrías navegar a la pantalla principal
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
    }
  }

  // Widget para crear un campo de texto genérico con decoración
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }

  // Widget para crear un campo de selección desplegable (Dropdown)
  Widget _buildDropdownField({
    required String labelText,
    required String? currentValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(labelText),
          value: currentValue,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Validación básica para campos de número
  String? _numberValidator(String? value, String fieldName, bool isInteger) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu $fieldName.';
    }
    final numValue = isInteger ? int.tryParse(value) : double.tryParse(value);
    if (numValue == null || numValue <= 0) {
      return 'Ingresa un valor válido para $fieldName.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configuración de Perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Color del texto
          ),
        ),
        backgroundColor: Colors.black, // Color de fondo del AppBar
        elevation: 0, // Sin sombra
        iconTheme: const IconThemeData(color: Colors.white), // Color de la flecha de regreso
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Título descriptivo
                const Text(
                  'Necesitamos algunos datos para personalizar tu plan nutricional.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 25.0),

                // Campo: Nombre
                _buildTextField(
                  controller: _nameController,
                  labelText: 'Nombre Completo',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu nombre.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),

                // Campo: Edad
                _buildTextField(
                  controller: _ageController,
                  labelText: 'Edad (años)',
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                  validator: (value) => _numberValidator(value, 'edad', true),
                ),
                const SizedBox(height: 15.0),

                // Campo: Género (Dropdown)
                _buildDropdownField(
                  labelText: 'Género',
                  currentValue: _gender,
                  items: _genderOptions,
                  icon: Icons.wc,
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue;
                    });
                  },
                ),
                const SizedBox(height: 15.0),

                // Campo: Altura
                _buildTextField(
                  controller: _heightController,
                  labelText: 'Altura (cm)',
                  icon: Icons.height,
                  keyboardType: TextInputType.number,
                  validator: (value) => _numberValidator(value, 'altura', false),
                ),
                const SizedBox(height: 15.0),

                // Campo: Peso
                _buildTextField(
                  controller: _weightController,
                  labelText: 'Peso Actual (kg)',
                  icon: Icons.scale,
                  keyboardType: TextInputType.number,
                  validator: (value) => _numberValidator(value, 'peso', false),
                ),
                const SizedBox(height: 20.0),
                
                // Subtítulo para Nivel de Actividad
                const Text(
                  'Nivel de Actividad Física',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 10.0),

                // Campo: Nivel de Actividad (Dropdown)
                _buildDropdownField(
                  labelText: 'Selecciona tu nivel de actividad',
                  currentValue: _activityLevel,
                  items: _activityLevels,
                  icon: Icons.fitness_center,
                  onChanged: (String? newValue) {
                    setState(() {
                      _activityLevel = newValue;
                    });
                  },
                ),
                const SizedBox(height: 30.0),

                // Botón de Guardar Perfil
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Color de fondo del botón
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Guardar Perfil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color del texto del botón
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}