import 'package:dashboard_application/services/api_service.dart';
import 'package:dashboard_application/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminService extends ApiService {
  static Future<Map<String, dynamic>> fetchDashboardStats() async {
    try {
      final response = await ApiService.handleRequest(
        http.get(
          Uri.parse('${ApiService.baseUrl}/dashboard/stats'),
          headers: ApiService.authenticatedHeaders,
        ),
        (data) => data as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return {'total_users': 0, 'total_requests': 0, 'total_revenue': 0.0};
    }
  }

  static Future<void> updateApiCost(double newCost) async {
    try {
      await ApiService.handleRequest(
        http.put(
          Uri.parse('${ApiService.baseUrl}/billing/admin/config'),
          headers: ApiService.authenticatedHeaders,
          body: json.encode({'new_cost': newCost}),
        ),
        (_) => null,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<UserModel>> fetchAllUsers() async {
    try {
      final users = await ApiService.handleRequest(
        http.get(
          Uri.parse('${ApiService.baseUrl}/users/'),
          headers: ApiService.authenticatedHeaders,
        ),
        (data) => data as List,
      );

      return users.map((item) => UserModel.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
