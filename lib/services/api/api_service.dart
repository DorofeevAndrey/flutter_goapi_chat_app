import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:8080/v1'; // замени на URL своего сервера

  Future<http.Response> register(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<http.Response> refreshToken(String? refreshToken) async {
    final url = Uri.parse('$baseUrl/auth/refresh');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );
  }
}
