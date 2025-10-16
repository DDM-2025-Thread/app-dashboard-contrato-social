import 'package:dashboard_application/models/user_model.dart';

List<UserModel> getUsersMock() {
  return [
    UserModel(id: 1, name: 'John Doe', email: 'john@example.com'),
    UserModel(id: 2, name: 'Jane Smith', email: 'jane@example.com'),
    UserModel(id: 3, name: 'Alice Johnson', email: 'alice@example.com'),
  ];
}
