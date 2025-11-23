class ApiKeyModel {
  final int? id;
  final String? userID;
  final String name;
  final String? key;
  final String status;
  final DateTime createdAt;

  ApiKeyModel({
    this.id,
    required this.name,
    this.userID,
    this.key,
    this.status = 'active',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) {
    return ApiKeyModel(
      id: json['id'],
      name: json['name'] ?? 'Sem nome',
      userID: json['userID'] ?? json['user_id'],
      key: json['key'],
      status: json['status'] ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "userID": userID,
    "key": key,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
  };
}
