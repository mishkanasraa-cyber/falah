import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_nav_scaffold.dart';
import '../surveyor/screen_43_search_for_farmer.dart';
import '../lands/screen_20_land_record_details.dart';

class Screen15FieldSurveyorHome extends StatefulWidget {
  const Screen15FieldSurveyorHome({super.key});

  @override
  State<Screen15FieldSurveyorHome> createState() =>
      _Screen15FieldSurveyorHomeState();
}

class _Screen15FieldSurveyorHomeState extends State<Screen15FieldSurveyorHome> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _appState.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FalahNavScaffold(
      activeTabIndex: 0,
      title: 'بوابة الحصر الزراعي الميداني',
      subtitle: 'حصر الأراضي وتوثيق الحيازات نيابة عن المزارعين',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Surveyor Hero Header
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0F3827), Color(0xFF166534)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.limeBright,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.assignment_ind_rounded,
                          color: AppColors.forestDarkest,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _appState.userName,
                              style: AppTypography.titleLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'موظف حصر معتمد • ${_appState.userMunicipality}',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.limeLight,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.limeBright,
                            foregroundColor: AppColors.forestDarkest,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Screen43SearchForFarmer(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.person_search_rounded,
                            size: 18,
                          ),
                          label: const Text(
                            'البحث عن مزارع',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.forestDarkest,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Screen43SearchForFarmer(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.post_add_rounded,
                            size: 18,
                            color: AppColors.forestDark,
                          ),
                          label: const Text(
                            'تسجيل أرض جديدة',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Badge & Guidance
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfacePure,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.forestPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'تذكير أمني: يتم تمييز مالك الأرض عن مدخل البيانات (موظف الحصر) تلقائياً لحفظ الحقوق العقارية.',
                            style: AppTypography.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Surveyor Statistics
                  Text(
                    'إحصائيات المهام الميدانية',
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSurveyorStat(
                        'حيازات تم توثيقها',
                        '${_appState.lands.length}',
                        AppColors.forestPrimary,
                      ),
                      const SizedBox(width: 10),
                      _buildSurveyorStat(
                        'مزارعون مصرح لهم',
                        '${_appState.farmersDirectory.length}',
                        AppColors.limeDark,
                      ),
                      const SizedBox(width: 10),
                      _buildSurveyorStat(
                        'بانتظار جُذور',
                        '1',
                        AppColors.statusReview,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recent Field Land Records
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'سجلات الأراضي الموثقة ميدانياً',
                        style: AppTypography.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Screen43SearchForFarmer(),
                            ),
                          );
                        },
                        child: const Text('دليل المزارعين'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ..._appState.lands.map((land) {
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.surfaceBorder),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: land.status.bgColor,
                          child: Icon(
                            land.status.icon,
                            color: land.status.color,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          land.landName,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'المالك: ${land.ownerName} • ${land.municipality} • (${land.recordNumber})',
                          style: AppTypography.bodySmall.copyWith(fontSize: 10),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                        ),
                        onTap: () {
                          _appState.setSelectedRecord(land);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  Screen20LandRecordDetails(record: land),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurveyorStat(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfacePure,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: AppTypography.displayMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppTypography.labelSmall.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
