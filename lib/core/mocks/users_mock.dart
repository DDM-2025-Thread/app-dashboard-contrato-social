import 'package:dashboard_application/models/user_model.dart';

List<UserModel> getUsersMock() {
  return [
    UserModel(name: 'John Doe', email: 'john@example.com', role: 'USER'),
    UserModel(name: 'Jane Smith', email: 'jane@example.com', role: 'USER'),
    UserModel(name: 'Alice Johnson', email: 'alice@example.com', role: 'USER'),
  ];
}
