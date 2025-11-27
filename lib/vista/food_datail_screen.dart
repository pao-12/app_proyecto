import 'dart:io';
import 'package:flutter/material.dart';
import '../Models/food_entry.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodEntry entry;

  const FoodDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Detalle del alimento'),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // IMAGEN SUPERIOR
            if (entry.imagePath != null && entry.imagePath!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: Image.file(
                  File(entry.imagePath!),
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            // CONTENEDOR DE DETALLES
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailItem("Categoría", entry.mealType),
                  const Divider(height: 25),

                  _detailItem("Nombre", entry.name),
                  const Divider(height: 25),

                  _detailItem("Descripción", entry.description ?? "Sin descripción"),
                  const Divider(height: 25),

                  _detailItem("Fecha", entry.date),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
