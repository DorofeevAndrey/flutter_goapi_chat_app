import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/api_service.dart';

class AuthService {
  final _api = ApiService();
  final _storage = const FlutterSecureStorage(); // для хранения токена
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<bool> register(String email, String password) async {
    final response = await _api.register(email, password);
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await _api.login(email, password);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await _storage.write(key: 'access_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);

      navigatorKey.currentState?.pushReplacementNamed('/home');

      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    navigatorKey.currentState?.pushReplacementNamed('/');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<String?> getValidAccessToken() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');

    if (accessToken == null || refreshToken == null) return null;

    // Декодируем access token, чтобы узнать его срок жизни
    final parts = accessToken.split('.');
    if (parts.length != 3) return null;

    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final exp = jsonDecode(payload)['exp'];

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Если не истёк, возвращаем токен
    if (now < exp) {
      return accessToken;
    }

    // Если истёк — обновляем
    try {
      final response = await _api.refreshToken(refreshToken);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'access_token', value: data['access_token']);
        await _storage.write(
          key: 'refresh_token',
          value: data['refresh_token'],
        );
        return data['access_token'];
      } else {
        // refresh не сработал — токены невалидны, выкидываем
        await logout();
        return null;
      }
    } catch (e) {
      print('Ошибка при обновлении токена: $e');
      return null;
    }
  }
}
