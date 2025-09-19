import 'package:dashboard_application/models/user_model.dart';

class UsageModel {
  final String id;
  final String userId;
  final String apiKeyId;
  final String endpoint;
  final DateTime timestamp;
  final double cost;

  UsageModel({
    required this.id,
    required this.userId,
    required this.apiKeyId,
    required this.endpoint,
    required this.timestamp,
    required this.cost,
  });

   factory UsageModel.fromJson(Map<String, dynamic> json) => UsageModel(
        id: json['id'],
        userId: json['userId'],
        apiKeyId: json['apiKeyId'],
        endpoint: json['endpoint'],
        timestamp: DateTime.parse(json['timestamp']),
        cost: (json['cost'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "apiKeyId": apiKeyId,
        "endpoint": endpoint,
        "timestamp": timestamp.toIso8601String(),
        "cost": cost,
      };
}

