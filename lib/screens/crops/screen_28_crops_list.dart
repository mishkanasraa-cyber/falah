import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';

class Screen28CropsList extends StatelessWidget {
  final LandRecord? landRecord;

  const Screen28CropsList({super.key, this.landRecord});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();
    final selectedLandId = landRecord?.id;

    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final records = appState.lands.where((land) {
          return selectedLandId == null || land.id == selectedLandId;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.warmBackground,
          appBar: AppBar(
            title: const Text('المحاصيل المسجلة'),
            backgroundColor: AppColors.forestDarkest,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: records.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'لا توجد سجلات أراضٍ لعرض محاصيلها.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return _buildLandCard(records[index]);
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLandCard(LandRecord land) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              land.landName,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.forestDarkest,
              ),
            ),
            const SizedBox(height: 6),
            Text('${land.recordNumber} • ${land.municipality}'),
            const SizedBox(height: 6),
            Text('عدد المحاصيل: ${land.crops.length}'),
            const Divider(height: 24),
            if (land.crops.isEmpty)
              const Text('لا توجد محاصيل مسجلة لهذه الأرض.')
            else
              ...land.crops.map(_buildCropTile),
          ],
        ),
      ),
    );
  }

  Widget _buildCropTile(CropItem crop) {
    final notes = crop.notes?.trim() ?? '';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.grass_rounded, color: AppColors.forestPrimary),
      title: Text(
        crop.cropType,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('الموسم: ${crop.season}'),
          Text(
            'المساحة المزروعة: '
            '${crop.cultivatedAreaHectares} هكتار',
          ),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('ملاحظات: $notes'),
          ],
        ],
      ),
    );
  }
}
