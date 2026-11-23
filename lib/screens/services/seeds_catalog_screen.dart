import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/crop_and_supply_model.dart';

class SeedsCatalogScreen extends StatefulWidget {
  const SeedsCatalogScreen({super.key});

  @override
  State<SeedsCatalogScreen> createState() => _SeedsCatalogScreenState();
}

class _SeedsCatalogScreenState extends State<SeedsCatalogScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<AgriculturalSupply> _supplies = AppConstants.getInitialSupplies();
  final List<LibyanCropSeason> _seasons = AppConstants.getCropSeasons();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('دليل البذور والأسمدة والروزنامة'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.limeBright,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'البذور والأسمدة المدعومة', icon: Icon(Icons.science_rounded)),
            Tab(text: 'الروزنامة ومواسم الزراعة', icon: Icon(Icons.calendar_month_rounded)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Seeds & Fertilizers
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _supplies.length,
            itemBuilder: (context, index) {
              final item = _supplies[index];
              return _buildSupplyCard(item);
            },
          ),

          // Tab 2: Libyan Crop Seasons
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _seasons.length,
            itemBuilder: (context, index) {
              final season = _seasons[index];
              return _buildSeasonCard(season);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupplyCard(AgriculturalSupply item) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.limeLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.category.icon, color: AppColors.limeDark, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.category.nameAr,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.forestPrimary),
                      ),
                    ],
                  ),
                ),
                if (item.subsidyPercentage > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.statusApprovedBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'دعم ${item.subsidyPercentage.toInt()}%',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.statusApproved,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(item.description, style: AppTypography.bodyMedium),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildSubRow('المحاصيل المستهدفة:', item.targetCrops),
                  const SizedBox(height: 4),
                  _buildSubRow('إرشادات الجرعة:', item.dosageGuideline),
                  const SizedBox(height: 4),
                  _buildSubRow('الجهة الموزعة:', item.libyanDistributor),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      item.isAvailableInCooperative ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      size: 16,
                      color: item.isAvailableInCooperative ? AppColors.statusApproved : AppColors.statusAlert,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.isAvailableInCooperative ? 'متوفر بمستودع الجمعية' : 'غير متوفر حالياً',
                      style: AppTypography.labelSmall.copyWith(
                        color: item.isAvailableInCooperative ? AppColors.statusApproved : AppColors.statusAlert,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم تسجيل طلب حجز حصة: ${item.name}')),
                    );
                  },
                  child: const Text('طلب حصة دعم'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonCard(LibyanCropSeason season) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceBorder, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.eco_rounded, color: AppColors.limeDark, size: 22),
                const SizedBox(width: 8),
                Text(
                  season.arabicName,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.forestDarkest,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.limeLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    season.seasonPeriod,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.limeDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warmBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                children: [
                  _buildSubRow('مواعيد البذر والغرس:', season.bestSowingMonths),
                  const SizedBox(height: 6),
                  _buildSubRow('موسم الحصاد والجني:', season.harvestMonths),
                  const SizedBox(height: 6),
                  _buildSubRow('احتياجات الري:', season.irrigationNeeds),
                  const SizedBox(height: 6),
                  _buildSubRow('التربة المفضلة:', season.soilPreference),
                  const SizedBox(height: 6),
                  _buildSubRow('المناطق الرئيسية:', season.primaryRegions.join('، ')),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.tips_and_updates_rounded, color: AppColors.forestPrimary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      season.tips,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.forestDarkest,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
