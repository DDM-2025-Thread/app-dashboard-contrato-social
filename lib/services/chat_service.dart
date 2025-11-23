import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/chat_model.dart';
import 'api_service.dart';

class ChatService extends ApiService {
  static const String endpoint = '/chat';

  static Future<List<ChatModel>> findByUser() async {
    return ApiService.handleListRequest<ChatModel>(
      http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint/find-by-user'),
        headers: ApiService.headers,
      ),
      (json) => ChatModel.fromJson(json),
    );
  }

  static Future<ChatModel> getResponse(String ticket) async {
    return ApiService.handleRequest<ChatModel>(
      http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint/get-response/$ticket'),
        headers: ApiService.headers,
      ),
      (data) => ChatModel.fromJson(data),
    );
  }

  static Future<String> upload(File pdfFile) async {
    final uri = Uri.parse('${ApiService.baseUrl}$endpoint/upload');
    final request = http.MultipartRequest('POST', uri);
    final headers = ApiService.headers;
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath('pdf_file', pdfFile.path),
    );
    final response = await request.send();
    final http.Response httpResponse = await http.Response.fromStream(response);
    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
      final data = json.decode(httpResponse.body);
      return data;
    } else {
      final errorBody = json.decode(httpResponse.body);
      throw Exception('Erro ${httpResponse.statusCode}: ${errorBody['detail'] ?? httpResponse.reasonPhrase}');
    }
  }
}

// final headers = await ApiService.getAuthHeaders();