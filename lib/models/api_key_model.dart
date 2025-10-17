class ApiKeyModel {
  final String id;
  final String userID;
  final String name;
  final String key;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ApiKeyModel({
    required this.id,
    required this.name,
    required this.userID,
    required this.key,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) => ApiKeyModel(
    id: json['id'],
    name: json['name'],
    userID: json['userID'],
    key: json['key'],
    status: json['status'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "userID": userID,
    "key": key,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt?.toIso8601String(),
  };
}
