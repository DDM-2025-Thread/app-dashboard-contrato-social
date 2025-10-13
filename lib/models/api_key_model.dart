class ApiKeyModel {
  final String id;
  final String userID;
  final String key;
  final String status;
  final DateTime createdAt;

  ApiKeyModel({
    required this.id,
    required this.userID,
    required this.key,
    required this.status,
    required this.createdAt,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) => ApiKeyModel(
    id: json['id'],
    userID: json['userID'],
    key: json['key'],
    status: json['status'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userID": userID,
    "key": key,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
  };
}
