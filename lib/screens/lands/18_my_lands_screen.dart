import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_nav_scaffold.dart';
import '../add_land/screen_21_add_land_owner_details.dart';
import '19_search_filter_lands_screen.dart';
import 'screen_20_land_record_details.dart';

class Screen18MyLands extends StatefulWidget {
  const Screen18MyLands({super.key});

  @override
  State<Screen18MyLands> createState() => _Screen18MyLandsState();
}

class _Screen18MyLandsState extends State<Screen18MyLands> {
  final AppState _appState = AppState();
  LandReviewStatus? _filterStatus;

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

  List<LandRecord> get _filteredLands {
    if (_filterStatus == null) return _appState.lands;
    return _appState.lands.where((l) => l.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lands = _filteredLands;

    return FalahNavScaffold(
      activeTabIndex: 1,
      title: 'سجل أراضيّ الزراعية',
      subtitle: '${_appState.lands.length} حيازات مسجلة في المنظومة',
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
          tooltip: 'البحث والفلترة المتقدمة',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Screen19SearchFilterLands()),
            );
          },
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.limeBright,
        foregroundColor: AppColors.forestDarkest,
        elevation: 4,
        onPressed: () {
          _appState.resetDraft();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Screen21AddLandOwnerDetails()),
          );
        },
        icon: const Icon(Icons.add_location_alt_rounded),
        label: Text(
          'إضافة أرض جديدة',
          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            color: AppColors.surfacePure,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    selected: _filterStatus == null,
                    label: Text('الكل (${_appState.lands.length})'),
                    selectedColor: AppColors.limeLight,
                    checkmarkColor: AppColors.limeDark,
                    onSelected: (_) => setState(() => _filterStatus = null),
                  ),
                  const SizedBox(width: 6),
                  FilterChip(
                    selected: _filterStatus == LandReviewStatus.approved,
                    label: const Text('معتمدة'),
                    selectedColor: AppColors.statusApprovedBg,
                    checkmarkColor: AppColors.statusApproved,
                    onSelected: (_) => setState(() => _filterStatus = LandReviewStatus.approved),
                  ),
                  const SizedBox(width: 6),
                  FilterChip(
                    selected: _filterStatus == LandReviewStatus.underReview,
                    label: const Text('قيد المراجعة'),
                    selectedColor: AppColors.statusReviewBg,
                    checkmarkColor: AppColors.statusReview,
                    onSelected: (_) => setState(() => _filterStatus = LandReviewStatus.underReview),
                  ),
                  const SizedBox(width: 6),
                  FilterChip(
                    selected: _filterStatus == LandReviewStatus.requiresModification,
                    label: const Text('يتطلب تعديلًا'),
                    selectedColor: AppColors.statusAlertBg,
                    checkmarkColor: AppColors.statusAlert,
                    onSelected: (_) => setState(() => _filterStatus = LandReviewStatus.requiresModification),
                  ),
                  const SizedBox(width: 6),
                  FilterChip(
                    selected: _filterStatus == LandReviewStatus.draft,
                    label: const Text('مسودات'),
                    selectedColor: AppColors.statusDraftBg,
                    checkmarkColor: AppColors.statusDraft,
                    onSelected: (_) => setState(() => _filterStatus = LandReviewStatus.draft),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 1),

          // Lands List or Empty State
          Expanded(
            child: lands.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceElevated,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.landscape_outlined, size: 54, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد أراضٍ بهذه الحالة',
                            style: AppTypography.titleLarge.copyWith(color: AppColors.forestDarkest),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'يمكنك البدء بتوثيق حيازتك الزراعية وتحديد حدودها على الخريطة.',
                            style: AppTypography.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.forestPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            onPressed: () {
                              _appState.resetDraft();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const Screen21AddLandOwnerDetails()),
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('إضافة أول أرض'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                    itemCount: lands.length,
                    itemBuilder: (context, index) {
                      final land = lands[index];
                      return _buildLandCard(context, land);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandCard(BuildContext context, LandRecord land) {
    final cropSummary = land.crops.isNotEmpty
        ? land.crops.map((c) => c.cropType.split('(').first.trim()).join('، ')
        : 'لم تضف محاصيل بعد';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _appState.setSelectedRecord(land);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Screen20LandRecordDetails(record: land)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Land Title & Status Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          land.landName,
                          style: AppTypography.titleLarge.copyWith(
                            color: AppColors.forestDarkest,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'رقم السجل: ${land.recordNumber}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.forestPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: land.status.bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: land.status.color.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(land.status.icon, size: 14, color: land.status.color),
                        const SizedBox(width: 4),
                        Text(
                          land.status.label,
                          style: AppTypography.labelSmall.copyWith(
                            color: land.status.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Municipality & Area
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'البلدية: ${land.municipality}',
                    style: AppTypography.bodySmall,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'المساحة: ${land.estimatedAreaDunams} دونم (${land.estimatedAreaHectares} هكتار)',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.forestDarkest,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Crops Summary
              Row(
                children: [
                  const Icon(Icons.eco_outlined, size: 16, color: AppColors.limeDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'المحاصيل: $cropSummary',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              if (land.status == LandReviewStatus.requiresModification) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.statusAlertBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.statusAlert),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'تنبيه: السجل يتطلب تعديلًا من قبلك (اضغط للاطلاع على السبب)',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.statusAlert,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
