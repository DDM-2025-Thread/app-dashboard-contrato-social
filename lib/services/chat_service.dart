import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../models/chat_model.dart';
import 'api_service.dart';

class ChatService extends ApiService {
  static const String endpoint = '/chat';

  static Future<List<ChatModel>> findByUser() async {
    return ApiService.handleListRequest<ChatModel>(
      http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint/find-by-user'),
        headers: ApiService.authenticatedHeaders,
      ),
      (json) => ChatModel.fromJson(json),
    );
  }

  static Future<ChatModel> getResponse(String ticket) async {
    return ApiService.handleRequest<ChatModel>(
      http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint/get-response/$ticket'),
        headers: ApiService.authenticatedHeaders,
      ),
      (data) => ChatModel.fromJson(data),
    );
  }

  static Future<String> upload(PlatformFile pdfFile) async {
    final uri = Uri.parse('${ApiService.baseUrl}$endpoint/upload');
    final request = http.MultipartRequest('POST', uri);
    final authHeaders = ApiService.authenticatedHeaders;
    authHeaders.forEach((key, value) {
      if (key.toLowerCase() != 'content-type') {
        request.headers[key] = value;
      }
    });

    http.MultipartFile multipartFile;
    if (pdfFile.bytes != null) {
      // WEB
      multipartFile = http.MultipartFile.fromBytes(
        'pdf_file',
        pdfFile.bytes!,
        filename: pdfFile.name,
      );
    } else if (pdfFile.path != null) {
      // NATIVE
      multipartFile = await http.MultipartFile.fromPath(
        'pdf_file',
        pdfFile.path!,
        filename: pdfFile.name,
      );
    } else {
      throw Exception(
        'Arquivo inválido: o arquivo não possui bytes nem caminho.',
      );
    }
    request.files.add(multipartFile);

    final response = await request.send();
    final http.Response httpResponse = await http.Response.fromStream(response);
    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
      final String ticketId = json.decode(httpResponse.body);
      return ticketId;
    } else {
      try {
        final errorBody = json.decode(httpResponse.body);
        throw Exception(
          'Erro ${httpResponse.statusCode}: ${errorBody['detail'] ?? httpResponse.reasonPhrase}',
        );
      } catch (_) {
        throw Exception(
          'Erro ${httpResponse.statusCode}: ${httpResponse.reasonPhrase}',
        );
      }
    }
  }
}
