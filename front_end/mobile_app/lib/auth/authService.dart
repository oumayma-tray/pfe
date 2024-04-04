// auth_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = "https://dev.app.smartovate.com";

  get mail => null;

  // Utilisateur de connexion
  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    final url = Uri.parse('$baseUrl/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'mail': mail,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Si le serveur retourne une réponse "200 OK", on parse le JSON.
      return json.decode(response.body);
    } else {
      // Si le serveur ne retourne pas une réponse "200 OK",
      // on lance une exception.
      throw Exception('Failed to load data');
    }
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    final url = Uri.parse('$baseUrl/reset-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      // Gérer les erreurs
      throw Exception('Failed to reset password');
    }
    // Si le serveur retourne une réponse "200 OK", on peut notifier l'utilisateur
    // que l'email de réinitialisation a été envoyé.
  }

  // Oubli du mot de passe
  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      // Gérer les erreurs
      throw Exception('Failed to send forgot password email');
    }
    // Si le serveur retourne une réponse "200 OK", on peut notifier l'utilisateur
    // que l'email pour oublier le mot de passe a été envoyé.
  }
}
