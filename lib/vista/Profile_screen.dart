import 'dart:io';

import 'package:contador_calorias/widgets/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'profile_form_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String email = "";
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // CARGAR DATOS DEL USUARIO
  void _loadUser() async {
    final user = await AuthService.instance.getUserData();
    setState(() {
      userName = user["name"] ?? "Usuario";
      email = user["email"] ?? "correo@ejemplo.com";
      photoUrl = user["photo"];
    });
  }

  // MOSTRAR ALERTA DE CONFIRMACIÓN
  Future<void> _confirmLogout() async {
    final bool? confirm = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.instance.logout();
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/auth',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            const Text(
              "Mi perfil",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // FOTO DE PERFIL
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 51,
                backgroundColor: Colors.white,
                backgroundImage:
                    photoUrl != null ? FileImage(File(photoUrl!)) : null,
                child: photoUrl == null
                    ? const Icon(Icons.person, size: 60, color: Colors.black)
                    : null,
              ),
            ),

            const SizedBox(height: 15),

            // NOMBRE
            Text(
              userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            // CORREO
            Text(
              email,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 25),

            // TARJETA 1
            _buildCard([
              _buildOption(
                Icons.edit,
                "Editar información de perfil",
                onTap: () async {
                  // Abrir formulario y recibir la nueva foto
                  final updatedPhoto = await Navigator.push<String?>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileFormScreen(),
                    ),
                  );

                  // Si se seleccionó una nueva foto, actualizarla
                  if (updatedPhoto != null && updatedPhoto.isNotEmpty) {
                    setState(() {
                      photoUrl = updatedPhoto;
                    });
                  }

                  // Recargar otros datos
                  _loadUser();
                },
              ),
              _buildOption(Icons.lock, "Políticas de seguridad y privacidad"),
            ]),

            const SizedBox(height: 10),

            // TARJETA 2 - CERRAR SESIÓN
            _buildCard([
              _buildOption(
                Icons.logout,
                "Cerrar sesión",
                isLogout: true,
                onTap: _confirmLogout,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // ----------------- WIDGETS -----------------
  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildOption(IconData icon, String text,
      {bool isLogout = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon,
                size: 22, color: isLogout ? Colors.red : Colors.grey[700]),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isLogout ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
