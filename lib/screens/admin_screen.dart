import 'package:dashboard_application/models/user_model.dart';
import 'package:dashboard_application/services/admin_service.dart';
import 'package:dashboard_application/utils/functions.dart';
import 'package:dashboard_application/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isLoading = true;

  final _costController = TextEditingController();
  double _currentCost = 0.0;

  int _totalUsers = 0;
  int _totalRequests = 0;
  double _totalRevenue = 0.0;

  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        AdminService.fetchAllUsers(),
        AdminService.fetchDashboardStats(),
        AdminService.getCurrentApiCost(),
      ]);

      final usersList = results[0] as List<UserModel>;
      final stats = results[1] as Map<String, dynamic>;

      _currentCost = results[2] as double;

      setState(() {
        _totalUsers = stats['total_users'] ?? usersList.length;
        _totalRequests = stats['total_requests'] ?? 0;
        _totalRevenue = stats['total_revenue']?.toDouble() ?? 0.0;
        _users = usersList;
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Erro ao carregar dados: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateCost() async {
    final newValue = double.tryParse(_costController.text.replaceAll(',', '.'));
    if (newValue == null || newValue < 0) {
      showSnackBar(context, 'Valor inválido', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AdminService.updateApiCost(newValue);
      setState(() {
        _currentCost = newValue;
      });
      if (mounted) showSnackBar(context, 'Custo atualizado com sucesso!');
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Erro ao atualizar: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadAdminData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsSection(),
            const SizedBox(height: 24),
            _buildConfigSection(),
            const SizedBox(height: 24),
            _buildUserManagementSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visão Geral do Sistema',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _metricCard(
                'Usuários',
                '$_totalUsers',
                Icons.people,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _metricCard(
                'Requisições',
                '$_totalRequests',
                Icons.cloud_download,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _metricCard(
          'Receita Total',
          'R\$ ${_totalRevenue.toStringAsFixed(2)}',
          Icons.attach_money,
          Colors.green,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _metricCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color),
              if (fullWidth)
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          if (!fullWidth)
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  Widget _buildConfigSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Colors.purple),
                const SizedBox(width: 8),
                const Text(
                  'Configuração de Cobrança',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Custo por Requisição (R\$)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _costController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,4}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: _currentCost.toStringAsFixed(2),
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CustomButton(
                  text: 'Salvar',
                  width: 100,
                  height: 48,
                  onPressed: _updateCost,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Valor atual em vigor: R\$ $_currentCost',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Usuários Recentes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            final isAdmin = user.role == 'ADMIN' || user.role == 'SUPER_ADMIN';

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isAdmin ? Colors.red[100] : Colors.blue[100],
                  child: Icon(
                    isAdmin ? Icons.security : Icons.person,
                    color: isAdmin ? Colors.red : Colors.blue,
                  ),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    showSnackBar(context, 'Ação: $value em ${user.name}');
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'promote',
                      child: Text('Tornar Admin'),
                    ),
                    const PopupMenuItem(
                      value: 'block',
                      child: Text(
                        'Bloquear Acesso',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }
}
