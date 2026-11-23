import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';

class Screen39ReturnedRecordExplanation extends StatelessWidget {
  final LandRecord record;

  const Screen39ReturnedRecordExplanation({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final reason = record.returnReason?.trim();
    final hasReason = reason != null && reason.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('سبب إرجاع السجل'),
        backgroundColor: AppColors.forestDarkest,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.assignment_return_outlined,
                size: 64,
                color: AppColors.statusAlert,
              ),
              const SizedBox(height: 16),
              Text(
                hasReason ? 'ملاحظات مراجعة السجل' : 'لا يوجد سبب إرجاع مسجّل',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestDarkest,
                ),
              ),
              const SizedBox(height: 24),

              // معلومات السجل.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.landName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('رقم السجل: ${record.recordNumber}'),
                      const SizedBox(height: 8),
                      Text('البلدية: ${record.municipality}'),
                      const SizedBox(height: 8),
                      Text('الحالة: ${record.status.label}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // سبب الإرجاع المسجل.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'سبب الإرجاع',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestDarkest,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        hasReason
                            ? reason
                            : 'لم تُسجّل ملاحظات إرجاع لهذا السجل.',
                        style: const TextStyle(fontSize: 15, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ),

              // عرض الحقول التي حددها المراجع.
              if (record.affectedFields.isNotEmpty) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'البيانات المطلوب تعديلها',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.forestDarkest,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...record.affectedFields.map(
                          (field) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.edit_note_rounded,
                                  color: AppColors.forestPrimary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    field,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('الرجوع إلى السجل'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
