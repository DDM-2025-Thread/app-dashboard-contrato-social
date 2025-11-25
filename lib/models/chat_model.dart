import 'dart:convert';

class ChatModel {
  final int id;
  final String ticketUuid;
  final String name;
  final String status;
  final DateTime createdAt;
  final int userId;
  final String? responseJson;
  final String? errorMessage;

  ChatModel({
    required this.id,
    required this.ticketUuid,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.userId,
    this.responseJson,
    this.errorMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final responseData = json['response_json'];
    String? encodedResponse;
    if (responseData != null) {
      if (responseData is Map<String, dynamic>) {
        encodedResponse = jsonEncode(responseData);
      } else if (responseData is String) {
        encodedResponse = responseData;
      }
    }

    return ChatModel(
      id: json['id'],
      ticketUuid: json['ticket_uuid'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      responseJson: encodedResponse,
      errorMessage: json['error_message'] != null
          ? json['error_message']
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticket_uuid": ticketUuid,
    "name": name,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "userID": userId,
    "response_json": responseJson,
    "error_message": errorMessage,
  };
}
