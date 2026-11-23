import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';

class Screen38TrackReviewStatus extends StatelessWidget {
  final LandRecord record;

  const Screen38TrackReviewStatus({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        // عرض أحدث نسخة من السجل إن وُجدت.
        final currentRecord = appState.lands.firstWhere(
          (item) => item.id == record.id,
          orElse: () => record,
        );

        return Scaffold(
          backgroundColor: AppColors.warmBackground,
          appBar: AppBar(
            title: const Text('متابعة مراجعة السجل'),
            backgroundColor: AppColors.forestDarkest,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentRecord.landName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.forestDarkest,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'رقم السجل: ${currentRecord.recordNumber}',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'البلدية: ${currentRecord.municipality}',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                currentRecord.status.icon,
                                color: currentRecord.status.color,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  currentRecord.status.label,
                                  style: TextStyle(
                                    color: currentRecord.status.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'مراحل مراجعة السجل',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.forestDarkest,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (currentRecord.reviewTimeline.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'لا توجد مراحل مراجعة مسجلة حتى الآن.',
                        ),
                      ),
                    ),

                  ...currentRecord.reviewTimeline.map(
                    (step) => _buildTimelineStep(step),
                  ),

                  if (currentRecord.status ==
                          LandReviewStatus.requiresModification &&
                      (currentRecord.returnReason?.trim().isNotEmpty ??
                          false)) ...[
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'سبب إرجاع السجل',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: AppColors.statusAlert,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currentRecord.returnReason!,
                              style: const TextStyle(height: 1.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('الرجوع إلى السجل'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineStep(ReviewTimelineStep step) {
    final Color color;
    final IconData icon;

    if (step.isError) {
      color = AppColors.statusAlert;
      icon = Icons.error_outline_rounded;
    } else if (step.isCurrent) {
      color = AppColors.forestPrimary;
      icon = Icons.pending_actions_rounded;
    } else if (step.isDone) {
      color = AppColors.forestPrimary;
      icon = Icons.check_circle_rounded;
    } else {
      color = Colors.grey;
      icon = Icons.radio_button_unchecked_rounded;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  if (step.isCurrent) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'المرحلة الحالية',
                      style: TextStyle(
                        color: AppColors.forestPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: const TextStyle(height: 1.6),
                  ),
                  if (step.date?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      step.date!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}