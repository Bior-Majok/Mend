import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/incident_model.dart';
import '../theme/app_theme.dart';

class StatusTimelineWidget extends StatelessWidget {
  final List<TimelineEvent> timeline;
  final IncidentStatus currentStatus;

  const StatusTimelineWidget({
    super.key,
    required this.timeline,
    required this.currentStatus,
  });

  String _formatDate(DateTime dt) {
    return DateFormat('MMM d, h:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    // Standard progression steps
    final steps = [
      IncidentStatus.submitted,
      IncidentStatus.inProgress,
      IncidentStatus.resolved,
    ];

    int activeIndex = 0;
    if (currentStatus == IncidentStatus.inProgress) {
      activeIndex = 1;
    } else if (currentStatus == IncidentStatus.resolved) {
      activeIndex = 2;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Connecting line
                final stepIndex = index ~/ 2;
                final isPassed = stepIndex < activeIndex;
                return Expanded(
                  child: Container(
                    height: 3.5,
                    color: isPassed
                        ? AppTheme.primaryColor
                        : const Color(0xFFD4E2D8),
                  ),
                );
              } else {
                // Node
                final stepIndex = index ~/ 2;
                final isCurrent = stepIndex == activeIndex;
                final isCompleted = stepIndex <= activeIndex;

                Color nodeColor;
                if (isCompleted) {
                  nodeColor = AppTheme.primaryColor;
                } else {
                  nodeColor = const Color(0xFFB0C4B8);
                }

                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? nodeColor : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: nodeColor,
                      width: isCurrent ? 3 : 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: nodeColor,
                            ),
                          ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.map((step) {
              final matchingEvent = timeline.cast<TimelineEvent?>().firstWhere(
                    (e) => e?.status == step,
                    orElse: () => null,
                  );

              final isCurrent = step == currentStatus;

              return SizedBox(
                width: 90,
                child: Column(
                  children: [
                    Text(
                      step.displayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.w600,
                        color: isCurrent
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                      ),
                    ),
                    if (matchingEvent != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(matchingEvent.timestamp),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
