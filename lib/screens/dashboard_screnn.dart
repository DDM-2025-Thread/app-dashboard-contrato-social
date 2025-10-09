import 'package:flutter/material.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/metric_card.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String _selectedPeriod = 'Últimos 30 dias';

  final List<Map<String, dynamic>> _metrics = [
    {
      'title': 'Revenue',
      'value': '\$59,782',
      'change': '+34%',
      'isPositive': true,
      'icon': Icons.attach_money,
      'color': Colors.green,
    },
    {
      'title': 'Page visitors',
      'value': '175K',
      'change': '+80%',
      'isPositive': true,
      'icon': Icons.people,
      'color': Colors.blue,
    },
    {
      'title': 'Pageviews',
      'value': '346K',
      'change': '+56%',
      'isPositive': true,
      'icon': Icons.visibility,
      'color': Colors.purple,
    },
    {
      'title': 'Bounce rate',
      'value': '64%',
      'change': '−80%',
      'isPositive': false,
      'icon': Icons.trending_down,
      'color': Colors.orange,
    },
    {
      'title': 'Visit duration',
      'value': '1m 8s',
      'change': '+9%',
      'isPositive': true,
      'icon': Icons.timer,
      'color': Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomScaffold(
      title: 'Dashboard',
      hasDrawer: false,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isDark),
            
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
                        'Page analytics',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ),
                    
                    // Metrics Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    _buildChartSection(context, isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
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
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _showPeriodFilter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedPeriod,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // User Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple.shade400,
              border: Border.all(
                color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

