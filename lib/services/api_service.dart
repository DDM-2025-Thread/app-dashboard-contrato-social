import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiService {
  static String? get baseUrl => dotenv.env['BASE_URL'];

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer ${AuthService.token}',
  };

  static Map<String, String> get authenticatedHeaders {
    try {
      final authService = _getAuthService();
      return {
        ...headers,
        if (authService?.token != null)
          'Authorization': 'Bearer ${authService!.token}',
      };
    } catch (e) {
      return headers;
    }
  }

  static dynamic _getAuthService() {
    // Em Dart, você pode usar esta abordagem ou mover a lógica
    return null; // Será implementado conforme necessário
  }

  static Future<T> handleRequest<T>(
    Future<http.Response> request,
    T Function(dynamic data) parser,
  ) async {
    try {
      final response = await request;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        return parser(data);
      } else {
        throw ApiException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Erro de conexão: $e', 0);
    }
  }

  static Future<List<T>> handleListRequest<T>(
    Future<http.Response> request,
    T Function(Map<String, dynamic> json) itemParser,
  ) async {
    return handleRequest<List<T>>(
      request,
      (data) => (data as List).map((json) => itemParser(json)).toList(),
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
