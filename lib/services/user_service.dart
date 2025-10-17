import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_service.dart';

class UserService extends ApiService {
  static const String endpoint = '/users';

  static Future<List<UserModel>> getUsers() async {
    return ApiService.handleListRequest<UserModel>(
      http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint'),
        headers: ApiService.headers,
      ),
      (json) => UserModel.fromJson(json),
    );
  }

  static Future<UserModel> getUserById(String id) async {
    return ApiService.handleRequest<UserModel>(
      http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint/$id'),
        headers: ApiService.headers,
      ),
      (data) => UserModel.fromJson(data),
    );
  }

  static Future<UserModel> createUser(UserModel user) async {
    return ApiService.handleRequest<UserModel>(
      http.post(
        Uri.parse('${ApiService.baseUrl}$endpoint'),
        headers: ApiService.headers,
        body: json.encode(user.toJson()),
      ),
      (data) => UserModel.fromJson(data),
    );
  }

  static Future<UserModel> updateUser(String id, UserModel user) async {
    return ApiService.handleRequest<UserModel>(
      http.put(
        Uri.parse('${ApiService.baseUrl}$endpoint/$id'),
        headers: ApiService.headers,
        body: json.encode(user.toJson()),
      ),
      (data) => UserModel.fromJson(data),
    );
  }

  static Future<bool> deleteUser(String id) async {
    return ApiService.handleRequest<bool>(
      http.delete(
        Uri.parse('${ApiService.baseUrl}$endpoint/$id'),
        headers: ApiService.headers,
      ),
      (data) => true,
    );
  }
}