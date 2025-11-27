import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../core/session_manager.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  static const String endpoint = '/auth';
  static const String _tokenKey = 'auth_token';

  static UserModel? _currentUser;

  static String? get token => SessionManager.token;
  static UserModel? get currentUser => _currentUser;
  static bool get isAuthenticated => SessionManager.token != null;

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    SessionManager.setToken(token);
  }

  static Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString(_tokenKey);

    if (storedToken != null) {
      SessionManager.setToken(storedToken);
    }
  }

  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}$endpoint/login'),
        headers: ApiService.headers,
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final token = data['token'];
        await _saveToken(token);

        if (data['user'] != null) {
          _currentUser = UserModel.fromJson(data['user']);
        } else {
          _currentUser = UserModel(
            name: data['name'],
            email: email,
            role: data['role'],
          );
        }

        return AuthResponse(
          success: true,
          token: token,
          user: _currentUser!,
          message: data['message']?.isNotEmpty == true
              ? data['message']
              : 'Login realizado com sucesso',
        );
      } else if (response.statusCode == 401) {
        throw ApiException('Credenciais inválidas', 401);
      } else {
        throw ApiException(
          'Erro no login: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão: $e', 0);
    }
  }

  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}$endpoint/register'),
        headers: ApiService.headers,
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        final token = data['token'];
        _currentUser = UserModel.fromJson(data['user']);
        await _saveToken(token);

        return AuthResponse(
          success: true,
          token: token,
          user: _currentUser!,
          message: 'Conta criada com sucesso',
        );
      } else if (response.statusCode == 409) {
        throw ApiException('Email já está em uso', 409);
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        throw ApiException(data['detail'] ?? 'Dados inválidos', 400);
      } else {
        throw ApiException(
          'Erro no registro: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão: $e', 0);
    }
  }

  static Future<void> logout() async {
    SessionManager.clear();
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

class AuthResponse {
  final bool success;
  final String token;
  final UserModel user;
  final String message;

  AuthResponse({
    required this.success,
    required this.token,
    required this.user,
    required this.message,
  });
}
