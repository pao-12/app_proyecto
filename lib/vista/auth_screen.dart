import 'package:flutter/material.dart';
import 'package:contador_calorias/main.dart';

import 'Main_screen.dart'; // Importamos MainScreen para navegar

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // 0: Bienvenida, 1: Login, 2: Register
  int _currentView = 0; 
  
  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Función para manejar la simulación de autenticación exitosa
  void _authenticateAndNavigate() {
    // Simula una lógica de autenticación (aquí iría la lógica real de Firebase/Auth)
    
    // Navega a la pantalla principal de la aplicación
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  // Widget para construir el formulario de Inicio de Sesión
  Widget _buildLoginForm() {
    return Column(
      children: [
        const Text(
          '¡Bienvenido de vuelta!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 30),
        
        // Campo de Email
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo Electrónico',
            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 20),
        
        // Campo de Contraseña
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 30),
        
        // Botón de Inicio de Sesión
        ElevatedButton(
          onPressed: _authenticateAndNavigate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Color negro
            minimumSize: const Size(double.infinity, 50), // Ancho completo
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Iniciar Sesión',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 15),

        // Botón para volver a la vista de Bienvenida
        TextButton(
          onPressed: () => setState(() => _currentView = 0),
          child: const Text('Volver', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  // Widget para construir el formulario de Registro
  Widget _buildRegisterForm() {
    return Column(
      children: [
        const Text(
          'Crea tu cuenta EATY',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 30),

        // Campo de Nombre de Usuario
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Nombre de Usuario',
            prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 20),

        // Campo de Email (Reutiliza el diseño del login)
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo Electrónico',
            prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 20),

        // Campo de Contraseña (Reutiliza el diseño del login)
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        const SizedBox(height: 30),

        // Botón de Registro
        ElevatedButton(
          onPressed: _authenticateAndNavigate, // Simula el registro exitoso
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600, // Color verde
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Registrarse',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        
        const SizedBox(height: 15),

        // Botón para volver a la vista de Bienvenida
        TextButton(
          onPressed: () => setState(() => _currentView = 0),
          child: const Text('Volver', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  // Widget para construir la vista de Bienvenida inicial
  Widget _buildWelcomeView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- LOGO (Logo.png) ---
        Image.asset(
          'assets/image/Logo.png',
          // Asegúrate de que el logo tenga el tamaño adecuado
          height: 150, 
        ),
        const SizedBox(height: 10),
        const Text(
          // Mantengo este texto debajo del logo si no está incluido en la imagen
          'Tu contador de calorías inteligente',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 80),
        
        // Botón de Iniciar Sesión
        ElevatedButton(
          onPressed: () => setState(() => _currentView = 1), // Cambia a vista de Login
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Iniciar Sesión',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Botón de Registrarse
        OutlinedButton(
          onPressed: () => setState(() => _currentView = 2), // Cambia a vista de Registro
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.black, width: 2),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            'Registrarse',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definimos el widget a mostrar basado en el estado
    Widget currentWidget;
    switch (_currentView) {
      case 1:
        currentWidget = _buildLoginForm();
        break;
      case 2:
        currentWidget = _buildRegisterForm();
        break;
      case 0:
      default:
        currentWidget = _buildWelcomeView();
        break;
    }

    return Scaffold(
      // Ya no definimos el color de fondo aquí, lo hace la imagen de fondo
      body: Stack(
        children: [
          // 1. Imagen de Fondo (Pantalla.png)
          Positioned.fill(
            child: Image.asset(
              'assets/image/Pantalla.png',
              fit: BoxFit.cover, // Asegura que la imagen cubra todo el espacio
              // Si la imagen es muy grande o muy pequeña, puedes usar BoxFit.fill
            ),
          ),

          // 2. Contenido de Autenticación
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 100, // Asegura que el contenido ocupe casi toda la altura
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: currentWidget,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}