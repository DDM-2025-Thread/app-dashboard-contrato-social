import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_service.dart';

class UserService extends ApiService {
  static const String endpoint = '/users';

  static Future<List<User>> getUsers() async {
    return ApiService.handleListRequest<User>(
      http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint'),
        headers: ApiService.headers,
      ),
      (json) => User.fromJson(json),
    );
  }

  static Future<User> getUserById(String id) async {
    return ApiService.handleRequest<User>(
      http.get(
        Uri.parse('${ApiService.baseUrl}$endpoint/$id'),
        headers: ApiService.headers,
      ),
      (data) => User.fromJson(data),
    );
  }

  static Future<User> createUser(User user) async {
    return ApiService.handleRequest<User>(
      http.post(
        Uri.parse('${ApiService.baseUrl}$endpoint'),
        headers: ApiService.headers,
        body: json.encode(user.toJson()),
      ),
      (data) => User.fromJson(data),
    );
  }

  static Future<User> updateUser(String id, User user) async {
    return ApiService.handleRequest<User>(
      http.put(
        Uri.parse('${ApiService.baseUrl}$endpoint/$id'),
        headers: ApiService.headers,
        body: json.encode(user.toJson()),
      ),
      (data) => User.fromJson(data),
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