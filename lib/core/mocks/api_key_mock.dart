import 'package:dashboard_application/models/api_key_model.dart';
import 'package:dashboard_application/models/user_model.dart';

List<ApiKeyModel> apiKeyMock = [
  ApiKeyModel(
    id: '1',
    user: User(id: 1, name: 'John Doe', email: 'john.doe@example.com'),
    key: 'api_key_1',
    status: 'active',
    createdAt: DateTime.now(),
  ),
  ApiKeyModel(
    id: '2',
    user: User(id: 2, name: 'Jane Smith', email: 'jane.smith@example.com'),
    key: 'api_key_2',
    status: 'inactive',
    createdAt: DateTime.now(),
  ),
];