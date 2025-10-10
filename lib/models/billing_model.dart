import 'package:dashboard_application/models/user_model.dart';

class BillingModel {
  final int id;
  final User user;
  final String period;
  final int total_requests;
  final double total_cost;
  final String status;

  BillingModel({
    required this.id,
    required this.user,
    required this.period,
    required this.total_requests,
    required this.total_cost,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'period': period,
      'total_requests': total_requests,
      'total_cost': total_cost,
      'status': status,
    };
  }

  factory BillingModel.fromMap(Map<String, dynamic> map) {
    return BillingModel(
      id: map['id'],
      user: User.fromMap(map['user']),
      period: map['period'],
      total_requests: map['total_requests'],
      total_cost: map['total_cost'],
      status: map['status'],
    );
  }

}
