import 'package:dashboard_application/models/billing_model.dart';

List<BillingModel> getBillingMock() {
  return [
    BillingModel(
      id: 1,
      userID: '1',
      period: '2023-01',
      total_requests: 100,
      total_cost: 29.99,
      status: 'paid',
    ),
    BillingModel(
      id: 2,
      userID: '2',
      period: '2023-02',
      total_requests: 200,
      total_cost: 59.99,
      status: 'pending',
    ),
  ];
}
