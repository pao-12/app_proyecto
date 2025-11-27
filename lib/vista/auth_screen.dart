import 'package:contador_calorias/widgets/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'Main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  int _currentView = 0;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String? emailError;
  String? passError;
  String? confirmPassError;
  String? nameError;

  late AnimationController _controller;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _slideUp = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  void _goTo(int view) {
    setState(() => _currentView = view);
    _controller.forward(from: 0);
    setState(() {
      emailError = passError = confirmPassError = nameError = null;
    });
  }

  bool validateRegister() {
    setState(() {
      nameError =
          _usernameController.text.trim().isEmpty ? "El nombre es obligatorio" : null;
      emailError =
          !_emailController.text.contains("@") ? "Correo inválido" : null;
      passError = _passwordController.text.length < 6
          ? "La contraseña debe tener mínimo 6 caracteres"
          : null;
      confirmPassError =
          _confirmPasswordController.text != _passwordController.text
              ? "Las contraseñas no coinciden"
              : null;
    });

    return nameError == null &&
        emailError == null &&
        passError == null &&
        confirmPassError == null;
  }

  bool validateLogin() {
    setState(() {
      emailError =
          !_emailController.text.contains("@") ? "Correo incorrecto" : null;
      passError = _passwordController.text.length < 6
          ? "Contraseña incorrecta"
          : null;
    });
    return emailError == null && passError == null;
  }

  void showAlert(String title, String msg, {bool success = true}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: success ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  // ✅ REGISTRO MODIFICADO
  Future<void> registerUser() async {
    if (!validateRegister()) return;

    await AuthService.instance.saveUserData(
      name: _usernameController.text.trim(),
      email: _emailController.text.trim(),
    );

    // ALERTA Y REGRESO A LOGIN
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Registro exitoso",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text("Tus datos se guardaron correctamente."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra alerta
              _goTo(1); //  Cambia a LOGIN
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> loginUser() async {
    if (!validateLogin()) return;

    showAlert("Inicio exitoso", "Bienvenido nuevamente.");

    await Future.delayed(const Duration(milliseconds: 700));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  // CAMPOS
  Widget _styledField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? error,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        errorText: error,
        prefixIcon: Icon(icon, color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  // BOTÓN MÁS CORTO
  Widget _primaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 350,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  // LOGIN FORM
  Widget _buildLoginForm() {
    return SlideTransition(
      position: _slideUp,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Iniciar Sesión",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            _styledField(
              controller: _emailController,
              label: "Correo electrónico",
              icon: Icons.email_outlined,
              error: emailError,
            ),
            const SizedBox(height: 15),

            _styledField(
              controller: _passwordController,
              label: "Contraseña",
              icon: Icons.lock_outline,
              obscure: true,
              error: passError,
            ),
            const SizedBox(height: 30),

            _primaryButton("Entrar", loginUser),

            TextButton(
              onPressed: () => _goTo(0),
              child: const Text("Volver", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  // REGISTER FORM
  Widget _buildRegisterForm() {
    return SlideTransition(
      position: _slideUp,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Crear Cuenta",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            _styledField(
              controller: _usernameController,
              label: "Nombre",
              icon: Icons.person_outline,
              error: nameError,
            ),
            const SizedBox(height: 12),

            _styledField(
              controller: _emailController,
              label: "Correo electrónico",
              icon: Icons.email_outlined,
              error: emailError,
            ),
            const SizedBox(height: 12),

            _styledField(
              controller: _passwordController,
              label: "Contraseña",
              icon: Icons.lock_outline,
              obscure: true,
              error: passError,
            ),
            const SizedBox(height: 12),

            _styledField(
              controller: _confirmPasswordController,
              label: "Confirmar contraseña",
              icon: Icons.lock_reset_outlined,
              obscure: true,
              error: confirmPassError,
            ),
            const SizedBox(height: 20),

            _primaryButton("Guardar", registerUser),

            TextButton(
              onPressed: () => _goTo(0),
              child: const Text("Volver", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/image/Logo.png', height: 150),
        const SizedBox(height: 8),
        const Text("Tu contador de calorías inteligente",
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 90),

        _primaryButton("Iniciar Sesión", () => _goTo(1)),
        const SizedBox(height: 18),

        _primaryButton("Registrar", () => _goTo(2)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget view;

    if (_currentView == 1) {
      view = _buildLoginForm();
    } else if (_currentView == 2) {
      view = _buildRegisterForm();
    } else {
      view = _buildWelcomeView();
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/Pantalla.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentView == 0
                    ? view
                    : Container(
                        key: ValueKey(_currentView),
                        width: MediaQuery.of(context).size.width * 0.78,
                        constraints: const BoxConstraints(
                          maxWidth: 380,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 22),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.93),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 9),
                            )
                          ],
                        ),
                        child: view,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


