class BillingModel {
  final int id;
  final String userID;
  final String period;
  final int total_requests;
  final double total_cost;
  final String status;

  BillingModel({
    required this.id,
    required this.userID,
    required this.period,
    required this.total_requests,
    required this.total_cost,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'period': period,
      'total_requests': total_requests,
      'total_cost': total_cost,
      'status': status,
    };
  }

  factory BillingModel.fromJson(Map<String, dynamic> json) {
    return BillingModel(
      id: json['id'],
      userID: json['userID'],
      period: json['period'],
      total_requests: json['total_requests'],
      total_cost: json['total_cost'],
      status: json['status'],
    );
  }

}
