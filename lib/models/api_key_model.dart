enum ApiKeyStatus { ativa, revogada, expirada }

ApiKeyStatus apiKeyStatusFromString(String status) {
  switch (status.toLowerCase()) {
    case 'ativa':
      return ApiKeyStatus.ativa;
    case 'revogada':
      return ApiKeyStatus.revogada;
    case 'expirada':
      return ApiKeyStatus.expirada;
    default:
      return ApiKeyStatus.revogada;
  }
}

String apiKeyStatusToString(ApiKeyStatus status) {
  return status.name; // ativa, revogada, expirada
}

class ApiKeyModel {
  final String id;
  final String userId;
  final String key;
  final ApiKeyStatus status;
  final DateTime createdAt;

  ApiKeyModel({
    required this.id,
    required this.userId,
    required this.key,
    required this.status,
    required this.createdAt,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) => ApiKeyModel(
    id: json['id'],
    userId: json['userId'],
    key: json['key'],
    status: apiKeyStatusFromString(json['status']),
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "key": key,
    "status": apiKeyStatusToString(status),
    "createdAt": createdAt.toIso8601String(),
  };
}
