import 'dart:convert';

class ChatModel {
  final int id;
  final String ticketUuid;
  final String status;
  final String? responseJson;
  final String? errorMessage;
  final DateTime createdAt;
  final int userId;

  ChatModel({
    required this.id,
    required this.ticketUuid,
    required this.status,
    this.responseJson,
    this.errorMessage,
    required this.createdAt,
    required this.userId,
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
      status: json['status'],
      responseJson: encodedResponse,
      errorMessage: json['error_message'] != null
          ? json['error_message']
          : null,
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "ticket_uuid": ticketUuid,
    "status": status,
    "response_json": responseJson,
    "error_message": errorMessage,
    "createdAt": createdAt.toIso8601String(),
    "userID": userId,
  };
}
