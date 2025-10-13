import 'package:dashboard_application/models/usage_log_model.dart';

List<UsageModel> getUsageLogMock() {
  return [
    UsageModel(
      id: '1',
      userID: '1',
      endpoint: '/api/v1/resource',
      timestamp: DateTime.now(),
      cost: 5.0,
    ),
    UsageModel(
      id: '2',
      userID: '2',
      endpoint: '/api/v1/resource',
      timestamp: DateTime.now(),
      cost: 5.0,
    ),
  ];
}
