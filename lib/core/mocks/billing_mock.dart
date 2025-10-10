import 'package:dashboard_application/models/billing_model.dart';
import 'package:dashboard_application/models/user_model.dart';

List<BillingModel> getBillingMock() {
  return [
    BillingModel(
      id: 1,
      user: User(id: 1, name: 'John Doe', email: 'john.doe@example.com'),
      period: '2023-01',
      total_requests: 100,
      total_cost: 29.99,
      status: 'paid',
    ),
    BillingModel(
      id: 2,
      user: User(id: 2, name: 'Jane Smith', email: 'jane.smith@example.com'),
      period: '2023-02',
      total_requests: 200,
      total_cost: 59.99,
      status: 'pending',
    ),
  ];
}
