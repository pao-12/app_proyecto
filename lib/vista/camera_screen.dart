import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  final String mealType;

  const CameraScreen({super.key, required this.mealType});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker picker = ImagePicker();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Abrir la cámara automáticamente después de que se construya el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takePhoto();
    });
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // optimiza tamaño
      );

      if (!mounted) return;

      if (picked != null) {
        // Devuelve automáticamente la ruta al RegisterScreen
        Navigator.pop(context, picked.path);
      } else {
        // Si cancela, regresa al formulario sin ruta
        Navigator.pop(context, null);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context, null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir la cámara: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pantalla de carga mientras se abre la cámara
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
