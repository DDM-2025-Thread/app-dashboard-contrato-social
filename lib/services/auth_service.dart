import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService extends ApiService {
  static const String endpoint = '/auth';

  static String? _token;
  static User? _currentUser;

  static String? get token => _token;
  static User? get currentUser => _currentUser;
  static bool get isAuthenticated => _token != null;

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

        _token = data['token'];

        if (data['user'] != null) {
          _currentUser = User.fromJson(data['user']);
        } else {
          _currentUser = User(id: data['id'], name: data['name'], email: email);
        }

        return AuthResponse(
          success: true,
          token: _token!,
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

      if (response.statusCode == 201) {
        final data = json.decode(response.body);

        _token = data['token'];
        _currentUser = User.fromJson(data['user']);

        return AuthResponse(
          success: true,
          token: _token!,
          user: _currentUser!,
          message: 'Conta criada com sucesso',
        );
      } else if (response.statusCode == 409) {
        throw ApiException('Email já está em uso', 409);
      } else if (response.statusCode == 400) {
        final data = json.decode(response.body);
        throw ApiException(data['message'] ?? 'Dados inválidos', 400);
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

  static void logout() {
    _token = null;
    _currentUser = null;
  }

  static Map<String, String> get authenticatedHeaders => {
    ...ApiService.headers,
    if (_token != null) 'Authorization': 'Bearer $_token',
  };
}

class AuthResponse {
  final bool success;
  final String token;
  final User user;
  final String message;

  AuthResponse({
    required this.success,
    required this.token,
    required this.user,
    required this.message,
  });
}
