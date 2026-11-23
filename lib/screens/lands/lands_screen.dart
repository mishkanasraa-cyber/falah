import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../../widgets/falah_app_bar.dart';
import '../../widgets/interactive_boundary_map.dart';
import 'screen_20_land_record_details.dart';
import '../add_land/screen_21_add_land_owner_details.dart';

class LandsScreen extends StatefulWidget {
  const LandsScreen({super.key});

  @override
  State<LandsScreen> createState() => _LandsScreenState();
}

class _LandsScreenState extends State<LandsScreen> {
  final AppState _appState = AppState();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  LandReviewStatus? _selectedStatusFilter;
  bool _showMapView = false;

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    _searchController.dispose();
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) {
      setState(() {});
    }
  }

  List<LandRecord> get _filteredLands {
    return _appState.lands.where((land) {
      final matchesSearch =
          land.landName.contains(_searchQuery) ||
          land.recordNumber.contains(_searchQuery) ||
          land.municipality.contains(_searchQuery) ||
          land.ownerName.contains(_searchQuery);

      final matchesStatus =
          _selectedStatusFilter == null || land.status == _selectedStatusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredLands;

    return Scaffold(
      appBar: FalahAppBar(
        title: 'سجل الحيازات والأراضي',
        subtitle: 'المخططات المساحية والتدقيق العقاري',
        customActions: [
          IconButton(
            icon: Icon(
              _showMapView ? Icons.view_list_rounded : Icons.map_rounded,
              color: Colors.white,
            ),
            tooltip: _showMapView ? 'عرض القائمة' : 'عرض الخريطة المساحية',
            onPressed: () => setState(() => _showMapView = !_showMapView),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.limeBright,
        foregroundColor: AppColors.forestDarkest,
        elevation: 4,
        onPressed: () {
          _appState.resetDraft();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const Screen21AddLandOwnerDetails(),
            ),
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
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: AppColors.surfacePure,
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'ابحث برقم القطعة، اسم المزرعة أو المنطقة...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.forestMedium,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        selected: _selectedStatusFilter == null,
                        label: Text('الكل (${_appState.lands.length})'),
                        selectedColor: AppColors.limeLight,
                        checkmarkColor: AppColors.limeDark,
                        onSelected: (_) =>
                            setState(() => _selectedStatusFilter = null),
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        selected:
                            _selectedStatusFilter == LandReviewStatus.approved,
                        label: const Text('معتمدة وموثقة'),
                        selectedColor: AppColors.statusApprovedBg,
                        checkmarkColor: AppColors.statusApproved,
                        onSelected: (_) => setState(
                          () =>
                              _selectedStatusFilter = LandReviewStatus.approved,
                        ),
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        selected:
                            _selectedStatusFilter ==
                            LandReviewStatus.underReview,
                        label: const Text('قيد المراجعة'),
                        selectedColor: AppColors.statusReviewBg,
                        checkmarkColor: AppColors.statusReview,
                        onSelected: (_) => setState(
                          () => _selectedStatusFilter =
                              LandReviewStatus.underReview,
                        ),
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        selected:
                            _selectedStatusFilter ==
                            LandReviewStatus.requiresModification,
                        label: const Text('يتطلب تعديلًا'),
                        onSelected: (_) => setState(
                          () => _selectedStatusFilter =
                              LandReviewStatus.requiresModification,
                        ),
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        selected:
                            _selectedStatusFilter == LandReviewStatus.draft,
                        label: const Text('مسودات'),
                        selectedColor: AppColors.statusDraftBg,
                        checkmarkColor: AppColors.statusDraft,
                        onSelected: (_) => setState(
                          () => _selectedStatusFilter = LandReviewStatus.draft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Main Content: List or Interactive Map Canvas
          Expanded(
            child: _showMapView
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الخريطة المساحية التفاعلية للقطع المسجلة (${filtered.length} قطعة):',
                          style: AppTypography.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView(
                            children: [
                              const Text(
                                'معاينة تخطيطية للحدود؛ ليست صور أقمار صناعية.',
                              ),
                              const SizedBox(height: 8),
                              for (final land in filtered)
                                Card(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(land.landName),
                                        subtitle: Text(land.status.label),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                Screen20LandRecordDetails(
                                                  record: land,
                                                ),
                                          ),
                                        ),
                                      ),
                                      if (land.boundaryPoints.length >= 3)
                                        InteractiveBoundaryMap(
                                          initialPoints: land.boundaryPoints,
                                          centerLocation: GeoPoint(
                                            land.latitude,
                                            land.longitude,
                                          ),
                                          isEditable: false,
                                          height: 220,
                                          showSatelliteToggle: false,
                                        )
                                      else
                                        const Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text('حدود الأرض غير مكتملة.'),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لا توجد أراضٍ مطابقة لمعايير البحث',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final land = filtered[index];
                      return _buildLandCard(context, land);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandCard(BuildContext context, LandRecord land) {
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Screen20LandRecordDetails(record: land),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title & Status Badge
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
                        const SizedBox(height: 3),
                        Text(
                          land.recordNumber,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.forestPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: land.status.bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: land.status.color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          land.status.icon,
                          size: 14,
                          color: land.status.color,
                        ),
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

              // Region & Area Row
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      land.municipality,
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${land.estimatedAreaDunams} دونم (${land.estimatedAreaHectares} هكتار)',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.forestDarkest,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Crops Tags
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: land.crops.map((crop) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.limeLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      crop.cropType,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.limeDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 6),

              // Card Footer: Attachments count & Details arrow
              Row(
                children: [
                  Icon(
                    Icons.attachment_rounded,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${land.attachments.length} مرفقات',
                    style: AppTypography.bodySmall.copyWith(fontSize: 11),
                  ),
                  const Spacer(),
                  Text(
                    'عرض التفاصيل والمخطط',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.forestPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.forestPrimary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
