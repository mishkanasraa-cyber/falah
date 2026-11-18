import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/ministry_order_model.dart';
import '../../models/user_role.dart';
import '../../services/app_state.dart';
import 'create_supply_request_dialog.dart';

class MinistryOrdersScreen extends StatefulWidget {
  const MinistryOrdersScreen({super.key});

  @override
  State<MinistryOrdersScreen> createState() => _MinistryOrdersScreenState();
}

class _MinistryOrdersScreenState extends State<MinistryOrdersScreen> with SingleTickerProviderStateMixin {
  final AppState _appState = AppState();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _appState.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _appState.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  void _openNewRequestDialog() {
    showDialog(
      context: context,
      builder: (_) => const CreateSupplyRequestDialog(),
    );
  }

  void _showVoucherDetails(MinistrySupplyOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfacePure,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ministry Official Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.forestDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_rounded, color: AppColors.limeBright, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'دولة ليبيا - وزارة الزراعة والثروة الحيوانية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                            ),
                          ),
                          Text(
                            'إذن صرف رسمي مدعوم - الجمعيات التعاونية الزراعية',
                            style: TextStyle(
                              color: AppColors.limeLight,
                              fontSize: 11,
                              fontFamilyFallback: AppTypography.arabicFontFamilyFallback,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Mock Digital QR Code Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceBorder, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Simulated QR Matrix
                    Container(
                      width: 130,
                      height: 130,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.forestPrimary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.qr_code_2_rounded, size: 80, color: AppColors.forestDarkest),
                          Text(
                            order.voucherCode,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'رمز التحقق لمستودع الصرف: ${order.voucherCode}',
                      style: AppTypography.titleSmall.copyWith(color: AppColors.forestDarkest, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'أبرز هذا الباركود لأمين مستودع الجمعية لتسليم الشحنة',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Order Details Table
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Column(
                  children: [
                    _buildVoucherRow('المستفيد:', order.farmerName),
                    _buildVoucherRow('بطاقة فلاح رقم:', order.agriculturalCardNumber),
                    _buildVoucherRow('الحيازة المخصصة:', order.landTitle),
                    _buildVoucherRow('المادة المعتمدة:', order.supplyName),
                    _buildVoucherRow('الكمية المصادق عليها:', order.approvedQuantity),
                    _buildVoucherRow('نسبة الدعم الحكومي:', '${order.subsidyPercentage.toInt()}% مدعوم من الوزارة'),
                    _buildVoucherRow('مستودع الاستلام:', order.pickupCooperative),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حفظ وتصدير إذن الصرف كملف PDF على الهاتف')),
                    );
                  },
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('تحميل إذن الصرف (PDF رسمي)'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildVoucherRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = _appState.ministryOrders;
    final approvedOrders = orders.where((o) => o.status == OrderStatus.approvedReadyForPickup).toList();
    final isCooperative = _appState.currentUser.role == UserRole.cooperative;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('منظومة صرف الأدوية والأسمدة والبذور'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.limeBright,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: 'جميع الطلبات والحصص (${orders.length})', icon: const Icon(Icons.inventory_rounded)),
            Tab(text: 'أذونات جاهزة للاستلام (${approvedOrders.length})', icon: const Icon(Icons.qr_code_rounded)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.limeBright,
        foregroundColor: AppColors.forestDarkest,
        elevation: 4,
        onPressed: _openNewRequestDialog,
        icon: const Icon(Icons.add_shopping_cart_rounded),
        label: Text(
          'طلب حصة جديدة',
          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: All Orders
          orders.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(order, isCooperative);
                  },
                ),

          // Tab 2: Ready for Pickup
          approvedOrders.isEmpty
              ? _buildEmptyState('لا توجد أذونات جاهزة للاستلام حالياً')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: approvedOrders.length,
                  itemBuilder: (context, index) {
                    final order = approvedOrders[index];
                    return _buildOrderCard(order, isCooperative);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState([String? msg]) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 54, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(msg ?? 'لم يتم تقديم طلبات حصص بعد', style: AppTypography.titleMedium),
          const SizedBox(height: 6),
          Text(
            'يمكنك طلب الأسمدة والبذور والأدوية الموصى بها لأرضك بسهولة',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.limeBright,
              foregroundColor: AppColors.forestDarkest,
            ),
            onPressed: _openNewRequestDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('تقديم طلب حصة الآن'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(MinistrySupplyOrder order, bool isCooperative) {
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
            // Header Row: Item Name & Status Pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.limeLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(order.category.icon, color: AppColors.limeDark, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.supplyName,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.forestDarkest,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'طلب رقم: ${order.id} • ${order.landTitle}',
                        style: AppTypography.bodySmall.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.status.bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(order.status.icon, size: 12, color: order.status.color),
                      const SizedBox(width: 4),
                      Text(
                        order.status.label,
                        style: AppTypography.labelSmall.copyWith(
                          color: order.status.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (order.recommendedByAi) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.limeLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 12, color: AppColors.limeDark),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        order.aiRecommendationReason ?? 'توصية مساعد فلاح الذكي',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.forestDarkest,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Order Metrics Row
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الكمية المطلوبة:', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                        Text(order.requestedQuantity, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الدعم الحكومي:', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                        Text('${order.subsidyPercentage.toInt()}% مدعوم', style: AppTypography.labelMedium.copyWith(color: AppColors.statusApproved, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('موقع الاستلام:', style: AppTypography.bodySmall.copyWith(fontSize: 10)),
                        Text(order.pickupCooperative.split('-').first.trim(), style: AppTypography.labelMedium.copyWith(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Bottom Actions (Pickup Voucher or Cooperative Approval)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order.status == OrderStatus.approvedReadyForPickup)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () => _showVoucherDetails(order),
                    icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                    label: const Text('عرض إذن الصرف والباركود'),
                  )
                else
                  Text(
                    order.status.description,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                  ),

                // If user switched to Cooperative role, allow direct approval
                if (isCooperative && order.status == OrderStatus.underReview)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.limeBright,
                      foregroundColor: AppColors.forestDarkest,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    onPressed: () {
                      _appState.approveMinistryOrder(order.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تمت الموافقة على طلب الصرف: ${order.supplyName}')),
                      );
                    },
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text('اعتماد الحصة (صلاحية الجمعية)'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
