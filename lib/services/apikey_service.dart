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
              'name': item['name'],
              'key': item['key'],
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
          return ApiKeyModel(name: name, key: data);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteApiKey(int id) async {
    try {
      await ApiService.handleRequest(
        http.delete(
          Uri.parse('${ApiService.baseUrl}$_endpoint/revoke/$id'),
          headers: ApiService.authenticatedHeaders,
        ),
        (_) => null,
      );
    } catch (e) {
      rethrow;
    }
  }
}
