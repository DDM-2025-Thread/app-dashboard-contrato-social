import 'package:dashboard_application/models/api_key_model.dart';

List<ApiKeyModel> getApiKeyMock() {
  return [
    ApiKeyModel(
      id: '1',
      userID: '1',
      key: 'api_key_1',
      status: 'active',
      createdAt: DateTime.now(),
    ),
    ApiKeyModel(
      id: '2',
      userID: '2',
      key: 'api_key_2',
      status: 'inactive',
      createdAt: DateTime.now(),
    ),
  ];
}
