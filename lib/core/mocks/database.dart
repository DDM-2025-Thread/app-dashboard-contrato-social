import 'package:dashboard_application/core/mocks/api_key_mock.dart';
import 'package:dashboard_application/core/mocks/billing_mock.dart';
import 'package:dashboard_application/core/mocks/usage_log_mock.dart';
import 'package:dashboard_application/core/mocks/users_mock.dart';
import 'package:dashboard_application/models/api_key_model.dart';
import 'package:dashboard_application/models/billing_model.dart';
import 'package:dashboard_application/models/usage_log_model.dart';
import 'package:dashboard_application/models/user_model.dart';

class MockDatabase {
  static final List<ApiKeyModel> _apiKeys = getApiKeyMock();
  static final List<BillingModel> _billingRecords = getBillingMock();
  static final List<UsageModel> _usageLogs = getUsageLogMock();
  static final List<UserModel> _users = getUsersMock();

  static List<ApiKeyModel> get apiKeys => _apiKeys;
  static List<BillingModel> get billingRecords => _billingRecords;
  static List<UsageModel> get usageLogs => _usageLogs;
  static List<UserModel> get users => _users;

  static void addApiKey(ApiKeyModel apiKey) {
    _apiKeys.add(apiKey);
  }

  static void addBillingRecord(BillingModel billing) {
    _billingRecords.add(billing);
  }

  static void addUsageLog(UsageModel usage) {
    _usageLogs.add(usage);
  }

  static void addUser(UserModel user) {
    _users.add(user);
  }
}
