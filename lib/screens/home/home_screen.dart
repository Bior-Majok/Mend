import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/incident_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/incident_card.dart';
import '../../widgets/metric_card.dart';
import '../reports/report_detail_screen.dart';
import '../reports/report_form_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSeeAllReports;

  const HomeScreen({super.key, required this.onSeeAllReports});

  @override
  Widget build(BuildContext context) {
    final authUser = context.watch<AuthProvider>().currentUser;
    final incidentProvider = context.watch<IncidentProvider>();
    final recentReports = incidentProvider.allIncidents.take(4).toList();

    final firstName = authUser?.fullName.split(' ').first ?? 'ALU Student';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 300));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.eco_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Mend',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Hello, $firstName 👋',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.primaryColor,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Help make our campus safer.\nReport issues and track their resolution.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD6E4DA)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: AppTheme.primaryColor,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No new campus broadcast notifications.'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(
                            firstName.isNotEmpty ? firstName[0] : 'U',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Report issue banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.primaryGradientStart,
                        AppTheme.primaryGradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'See an issue\non campus?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.15,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Report it and help improve\nour learning environment.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD6EBE0),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReportFormScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 20),
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Report an Issue',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.chevron_right, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Report Summary Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Report Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: onSeeAllReports,
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Summary metric cards
                Row(
                  children: [
                    MetricCard(
                      count: '${incidentProvider.myReportsCount(authUser?.uid)}',
                      label: 'My Reports',
                      backgroundColor: AppTheme.metricForestBg,
                      textColor: AppTheme.primaryColor,
                      icon: Icons.article_outlined,
                      onTap: onSeeAllReports,
                    ),
                    const SizedBox(width: 8),
                    MetricCard(
                      count: '${incidentProvider.inProgressCount}',
                      label: 'In Progress',
                      backgroundColor: AppTheme.metricAmberBg,
                      textColor: AppTheme.statusInProgressColor,
                      icon: Icons.hourglass_top_rounded,
                      onTap: () {
                        incidentProvider.setStatusFilter('In Progress');
                        onSeeAllReports();
                      },
                    ),
                    const SizedBox(width: 8),
                    MetricCard(
                      count: '${incidentProvider.resolvedCount}',
                      label: 'Resolved',
                      backgroundColor: AppTheme.metricGreenBg,
                      textColor: AppTheme.statusResolvedColor,
                      icon: Icons.check_circle_outline,
                      onTap: () {
                        incidentProvider.setStatusFilter('Resolved');
                        onSeeAllReports();
                      },
                    ),
                    const SizedBox(width: 8),
                    MetricCard(
                      count: '${incidentProvider.submittedCount}',
                      label: 'Submitted',
                      backgroundColor: AppTheme.metricSageBg,
                      textColor: AppTheme.primaryColor,
                      icon: Icons.priority_high_rounded,
                      onTap: () {
                        incidentProvider.setStatusFilter('Submitted');
                        onSeeAllReports();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Reports Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Reports',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: onSeeAllReports,
                      child: const Text(
                        'See all',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (recentReports.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD6E4DA)),
                    ),
                    child: const Center(
                      child: Text(
                        'No incident reports yet. Tap "Report an Issue" to start.',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    ),
                  )
                else
                  ...recentReports.map(
                    (report) => IncidentCard(
                      incident: report,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReportDetailScreen(incident: report),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
