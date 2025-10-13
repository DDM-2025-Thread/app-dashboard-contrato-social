class UsageModel {
  final String id;
  final String userID;
  final String endpoint;
  final DateTime timestamp;
  final double cost;

  UsageModel({
    required this.id,
    required this.userID,
    required this.endpoint,
    required this.timestamp,
    required this.cost,
  });
  
  Map<String, dynamic> toJson() => {
    "id": id,
    "userID": userID,
    "endpoint": endpoint,
    "timestamp": timestamp.toIso8601String(),
    "cost": cost,
  };

  factory UsageModel.fromJson(Map<String, dynamic> json) => UsageModel(
    id: json['id'],
    userID: json['userID'],
    endpoint: json['endpoint'],
    timestamp: DateTime.parse(json['timestamp']),
    cost: (json['cost'] as num).toDouble(),
  );
}
