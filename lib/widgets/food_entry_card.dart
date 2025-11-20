import 'package:flutter/material.dart';
import '../Models/food_entry.dart';
import '../utils/database_helper.dart';

// Definición de tipo para los callbacks
typedef OnEntryAction = void Function();

// Opciones para el menú de acciones de cada tarjeta
enum MenuOptions { edit, delete }

class FoodEntryCard extends StatelessWidget {
  final FoodEntry entry;
  final OnEntryAction onEdit;    // Callback para iniciar la edición (navegación a RegisterScreen)
  final OnEntryAction onDelete;  // Callback para refrescar la lista después de eliminar

  const FoodEntryCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  // --- FUNCIÓN CRUD: DELETE ---
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar el registro de "${entry.name}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        // Llama a la operación DELETE del DatabaseHelper
        await DatabaseHelper.instance.deleteFoodEntry(entry.id!);
        
        // Notifica a la pantalla principal para recargar la lista
        onDelete(); 
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${entry.name} ha sido eliminado con éxito.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Contenido principal de la tarjeta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(entry.description ?? '', style: TextStyle(fontSize: 14, color: Colors.grey.shade600), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            
            // Menú de 3 Puntos para acciones (EDITAR y ELIMINAR)
            PopupMenuButton<MenuOptions>(
              onSelected: (MenuOptions result) {
                switch (result) {
                  case MenuOptions.edit:
                    onEdit(); // Llama al callback para iniciar la edición
                    break;
                  case MenuOptions.delete:
                    _showDeleteConfirmationDialog(context); // Inicia la confirmación de eliminación
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuOptions>>[
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.edit,
                  child: Row(children: [Icon(Icons.edit, color: Colors.blue), SizedBox(width: 8), Text('Editar')]),
                ),
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.delete,
                  child: Row(children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Eliminar')]),
                ),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}