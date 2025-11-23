import 'package:dashboard_application/models/api_key_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ApiKeyService extends ApiService {
  static const String _endpoint = '/apikeys';

  static Future<List<ApiKeyModel>> getApiKeys() async {
    try {
      return await ApiService.handleRequest<List<ApiKeyModel>>(
        http.get(
          Uri.parse('${ApiService.baseUrl}$_endpoint/'),
          headers: ApiService.authenticatedHeaders,
        ),
        (body) {
          final data = body['data'];
          final List<dynamic> list = data != null ? data['api_keys'] : [];

          return list.map((item) {
            return ApiKeyModel.fromJson({
              ...item,
              'id': item['id'],
              'userID': item['user_id'],
              'status': item['status'],
              'createdAt': item['created_at'],
            });
          }).toList();
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ApiKeyModel> createApiKey(String name) async {
    try {
      return await ApiService.handleRequest<ApiKeyModel>(
        http.post(
          Uri.parse('${ApiService.baseUrl}$_endpoint/generate'),
          headers: ApiService.authenticatedHeaders,
          body: json.encode({'name': name}),
        ),
        (body) {
          final data = body['data']['api_key'];
          return ApiKeyModel(
            name: data['name'] ?? name,
            key: data['key'] ?? data,

            // retirar valores abaixo (x), é só para não bugar
            id: '1', // x
            userID: '1', // x
            status: 'ACTIVE', // x
            createdAt: DateTime.now().toUtc(), // x
          );
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteApiKey(String id) async {
    try {
      await ApiService.handleRequest(
        http.delete(
          Uri.parse('${ApiService.baseUrl}$_endpoint/$id'),
          headers: ApiService.authenticatedHeaders,
        ),
        (_) => null,
      );
    } catch (e) {
      rethrow;
    }
  }
}
