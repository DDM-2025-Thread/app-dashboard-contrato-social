import 'package:dashboard_application/models/user_model.dart';

class ApiKeyModel {
  final String id;
  final User user;
  final String key;
  final String status;
  final DateTime createdAt;

  ApiKeyModel({
    required this.id,
    required this.user,
    required this.key,
    required this.status,
    required this.createdAt,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) => ApiKeyModel(
    id: json['id'],
    user: User.fromMap(json['user']),
    key: json['key'],
    status: json['status'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toMap(),
    "key": key,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
  };
}
