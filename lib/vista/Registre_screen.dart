import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../Models/food_entry.dart';
import '../utils/database_helper.dart';

class RegisterScreen extends StatefulWidget {
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
  late String _selectedMealType;

  final List<String> _mealTypes = ['Desayuno', 'Almuerzo', 'Cena', 'Bebidas'];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool get isEditing => widget.entryToEdit != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final entry = widget.entryToEdit!;
      _nameController = TextEditingController(text: entry.name);
      _descriptionController = TextEditingController(text: entry.description);
      _selectedMealType = entry.mealType;
      if (entry.imagePath != null && entry.imagePath!.isNotEmpty) {
        _imageFile = File(entry.imagePath!);
      }
    } else {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _selectedMealType = widget.initialMealType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ABRIR GALERÍA Y SELECCIONAR FOTO
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked != null && mounted) {
        setState(() {
          _imageFile = File(picked.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir la galería: $e')),
      );
    }
  }

  // GUARDAR REGISTRO O ACTUALIZACIÓN
  void _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    final entry = FoodEntry(
      id: isEditing ? widget.entryToEdit!.id : null,
      mealType: _selectedMealType,
      name: _nameController.text,
      description: _descriptionController.text,
      date: isEditing
          ? widget.entryToEdit!.date
          : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      calories: 0,
      carbs: 0,
      fats: 0,
      proteins: 0,
      imagePath: _imageFile?.path,
    );

    try {
      if (isEditing) {
        await DatabaseHelper.instance.updateFoodEntry(entry);
      } else {
        await DatabaseHelper.instance.insertFoodEntry(entry);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isEditing ? 'Alimento actualizado' : 'Alimento registrado'),
          backgroundColor: Colors.green.shade600,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar alimento' : 'Registrar alimento',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _card(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de comida',
                    border: InputBorder.none,
                  ),
                  value: _selectedMealType,
                  items: _mealTypes
                      .map((meal) =>
                          DropdownMenuItem(value: meal, child: Text(meal)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedMealType = value!),
                ),
              ),
              _card(
                child: TextFormField(
                  controller: _nameController,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del alimento',
                    icon: Icon(Icons.fastfood),
                    border: InputBorder.none,
                  ),
                ),
              ),
              _card(
                child: TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  decoration: const InputDecoration(
                    labelText: 'Descripción / Porción',
                    icon: Icon(Icons.description),
                    border: InputBorder.none,
                  ),
                ),
              ),

              // PREVISUALIZACIÓN DE IMAGEN
              if (_imageFile != null)
               ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.file(
                    _imageFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),


              const SizedBox(height: 20),

              // BOTÓN AGREGAR / CAMBIAR FOTO
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo, color: Colors.white),
                  label: Text(
                    _imageFile != null ? 'Cambiar foto' : 'Agregar foto',
                    style:
                        const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // BOTÓN GUARDAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Actualizar' : 'Guardar',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
