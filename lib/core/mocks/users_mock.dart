import 'package:dashboard_application/models/user_model.dart';

List<User> getUsersMock() {
  return [
    User(id: 1, name: 'John Doe', email: 'john@example.com'),
    User(id: 2, name: 'Jane Smith', email: 'jane@example.com'),
    User(id: 3, name: 'Alice Johnson', email: 'alice@example.com'),
  ];
}
