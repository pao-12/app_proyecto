import 'package:flutter/material.dart';
import '../Models/user.dart';
import '../utils/database_helper.dart';
import 'profile_edit_screen.dart'; // Importamos la pantalla de edición

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Future que contendrá los datos del usuario.
  Future<User?>? _userFuture;

  @override
  void initState() {
    super.initState();
    // Inicia la carga de datos del usuario al entrar a la pantalla (Operación READ).
    _loadUserProfile(); 
  }

  // Función para cargar los datos del usuario
  void _loadUserProfile() {
    setState(() {
      _userFuture = DatabaseHelper.instance.getPrimaryUser();
    });
  }

  // Función para navegar a la pantalla de edición
  void _navigateToEditScreen(User user) async {
    // Navega y espera el resultado. Si retorna true, es que se actualizó.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditScreen(user: user),
      ),
    );

    // Si la edición fue exitosa, recarga el perfil para ver los cambios.
    if (result == true) {
      _loadUserProfile();
    }
  }

  // Widget para mostrar una fila de información (Título y Valor)
  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade600, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<User?>(
        // El Future que realiza la operación READ
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras espera los datos (simulación de DB)
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (snapshot.hasError) {
            // Si hay un error en la lectura
            return Center(child: Text('Error al cargar el perfil: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // Datos cargados con éxito
            final user = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- Sección Superior: Nombre y Objetivo ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.username,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Objetivo: ${user.dailyCalorieGoal ?? 'N/A'} kcal/día',
                              style: TextStyle(fontSize: 16, color: Colors.green.shade700),
                            ),
                          ],
                        ),
                        // Botón de Editar
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green.shade700, size: 28),
                          onPressed: () => _navigateToEditScreen(user),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Sección de Información Detallada ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Edad', '${user.age ?? 'N/A'} años', Icons.cake),
                        const Divider(),
                        _buildInfoRow('Altura', '${user.heightCm ?? 'N/A'} cm', Icons.height),
                        const Divider(),
                        _buildInfoRow('Peso', '${user.weightKg ?? 'N/A'} kg', Icons.scale),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Si no hay datos (ej. primer uso de la app)
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No se encontraron datos de perfil.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Aquí se navegaría a ProfileFormScreen para la CREACIÓN inicial
                        // (Por simplicidad, recargaremos el mock para demostrar)
                        _loadUserProfile(); 
                      },
                      icon: const Icon(Icons.person_add, color: Colors.white),
                      label: const Text('Crear Perfil Ahora', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}