import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Constructor privado para patrón Singleton
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  /// Guarda los datos del usuario
  Future<void> saveUserData({
    required String name,
    required String email,
    String? photo,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', name.trim());
    await prefs.setString('email', email.trim());

    if (photo != null && photo.isNotEmpty) {
      await prefs.setString('photo', photo);
    }
  }

  /// Obtiene los datos del usuario
  Future<Map<String, String?>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'photo': prefs.getString('photo'),
    };
  }

  /// Verifica si hay usuario guardado
  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('email');
  }

  /// Limpia la sesión del usuario
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('photo');
  }
}
