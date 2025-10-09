import 'package:dashboard_application/models/user_model.dart';

class UsageModel {
  final String id;
  final User user;
  final String endpoint;
  final DateTime timestamp;
  final double cost;

  UsageModel({
    required this.id,
    required this.user,
    required this.endpoint,
    required this.timestamp,
    required this.cost,
  });
  
  Map<String, dynamic> toMap() => {
    "id": id,
    "user": user.toMap(),
    "endpoint": endpoint,
    "timestamp": timestamp.toIso8601String(),
    "cost": cost,
  };

  factory UsageModel.fromMap(Map<String, dynamic> json) => UsageModel(
    id: json['id'],
    user: User.fromMap(json['user']),
    endpoint: json['endpoint'],
    timestamp: DateTime.parse(json['timestamp']),
    cost: (json['cost'] as num).toDouble(),
  );
}
