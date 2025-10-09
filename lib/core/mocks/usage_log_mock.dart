import 'package:dashboard_application/models/usage_log_model.dart';
import 'package:dashboard_application/models/user_model.dart';

List<UsageModel> usageLogMock = [
  UsageModel(
    id: '1',
    user: User(id: 1, name: 'John Doe', email: 'john.doe@example.com'),
    endpoint: '/api/v1/resource',
    timestamp: DateTime.now(),
    cost: 0.0,
  ),
  UsageModel(
    id: '2',
    user: User(id: 2, name: 'Jane Smith', email: 'jane.smith@example.com'),
    endpoint: '/api/v1/resource',
    timestamp: DateTime.now(),
    cost: 0.0,
  ),
];