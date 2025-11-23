import 'package:dashboard_application/models/api_key_model.dart';

List<ApiKeyModel> getApiKeyMock() {
  return [
    ApiKeyModel(
      id: 1,
      name: 'Chave 1',
      userID: '1',
      key: 'api_key_1',
      status: 'active',
      createdAt: DateTime.now(),
    ),
  ];
}
