import 'package:flutter/material.dart';
import '../models/incident_model.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final IncidentStatus status;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.status,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case IncidentStatus.submitted:
        textColor = AppTheme.statusSubmittedColor;
        bgColor = AppTheme.statusSubmittedBg;
        break;
      case IncidentStatus.inProgress:
        textColor = AppTheme.statusInProgressColor;
        bgColor = AppTheme.statusInProgressBg;
        break;
      case IncidentStatus.resolved:
        textColor = AppTheme.statusResolvedColor;
        bgColor = AppTheme.statusResolvedBg;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 9 : 13,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor.withOpacity(0.2), width: 1),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: isSmall ? 11 : 12,
        ),
      ),
    );
  }
}
