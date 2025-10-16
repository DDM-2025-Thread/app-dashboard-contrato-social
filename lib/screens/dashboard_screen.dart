import 'package:dashboard_application/core/mocks/database.dart';
import 'package:dashboard_application/models/usage_log_model.dart';
import 'package:dashboard_application/utils/constant.dart';
import 'package:flutter/material.dart';
import '../widgets/metric_card.dart';
import '../widgets/line_chart_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String _selectedPeriod = 'Últimos 30 dias';
  DateTime _selectedDate = DateTime.now().subtract(const Duration(days: 30));
  final today = DateTime.now();
  List<UsageModel> usageLogs = MockDatabase.usageLogs;

  late List<Map<String, dynamic>> _metrics;

  @override
  void initState() {
    super.initState();
    _metrics = [
      {
        'title': 'Total Uso Diario',
        'value': _getDailyUsage(),
        'change': '',
        'isPositive': true,
        'icon': Icons.swap_horiz,
        'color': Colors.purple.shade500,
      },
      {
        'title': 'Total Gasto',
        'value': 'R\$${_getTotalCost()}',
        'change': '',
        'isPositive': true,
        'icon': Icons.money,
        'color': Colors.green,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
        child: Column(
          children: [
            _buildHeader(context, theme, colorScheme),

            // Metrics Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Analytics Title
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        AppConstants.homeSubtitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),

                    // Metrics Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                      itemCount: _metrics.length,
                      itemBuilder: (context, index) => MetricCard(
                        title: _metrics[index]['title'],
                        value: _metrics[index]['value'],
                        change: _metrics[index]['change'],
                        isPositive: _metrics[index]['isPositive'],
                        icon: _metrics[index]['icon'],
                        color: _metrics[index]['color'],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Chart Section
                    _buildChartSection(context, theme, colorScheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                colorScheme.outline ?? colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // Filter Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    colorScheme.outline ??
                    colorScheme.onSurface.withOpacity(0.2),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _showPeriodFilter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedPeriod,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visitors Overview - November',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total visitors for the selected period',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChartWidget(
              data: [12000, 18000, 14000, 22000, 19000, 25000, 28000],
              labels: ['1', '5', '10', '15', '20', '25', '30'],
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getDailyUsage() {
    final dailyUsage = usageLogs
        .where(
          (log) =>
              log.timestamp.year == today.year &&
              log.timestamp.month == today.month &&
              log.timestamp.day == today.day,
        )
        .length;
    return dailyUsage.toString();
  }

  String _getTotalCost() {
    final totalCost = usageLogs
        .where(
          (log) => log.timestamp.isAfter(_selectedDate),
        )
        .fold<double>(0.0, (sum, log) => sum + log.cost);
    return totalCost.toString();
  }

  void _showPeriodFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select Period',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              ...[
                'Últimos 7 dias',
                'Últimos 30 dias',
                'Últimos 90 dias',
                'Este ano',
              ].map(
                (period) => ListTile(
                  title: Text(
                    period,
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  trailing: _selectedPeriod == period
                      ? Icon(Icons.check, color: colorScheme.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedPeriod = period);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
