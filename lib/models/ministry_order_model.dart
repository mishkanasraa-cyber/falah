import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'crop_and_supply_model.dart';

enum OrderStatus {
  underReview(
    label: 'قيد مراجعة مراقبة الزراعة',
    description: 'يتم تدقيق مطابقة الحصة مع مساحة الحيازة بالسجل العقاري',
    color: AppColors.statusReview,
    bgColor: AppColors.statusReviewBg,
    icon: Icons.hourglass_top_rounded,
  ),
  approvedReadyForPickup(
    label: 'معتمد وجاهز للاستلام',
    description: 'تم إصدار إذن الصرف الرسمي. يرجى التوجه لمستودع الجمعية',
    color: AppColors.statusApproved,
    bgColor: AppColors.statusApprovedBg,
    icon: Icons.check_circle_rounded,
  ),
  fulfilled(
    label: 'تم الاستلام بنجاح',
    description: 'تم تسليم الحصة للمزارع بموجب الباركود وإيصال المخزن',
    color: AppColors.forestPrimary,
    bgColor: Color(0xFFDCFCE7),
    icon: Icons.task_alt_rounded,
  ),
  rejected(
    label: 'طلب غير مطابق',
    description: 'الحصة المطلوبة تتجاوز السقف السنوي المسموح للحيازة',
    color: AppColors.statusAlert,
    bgColor: AppColors.statusAlertBg,
    icon: Icons.cancel_rounded,
  );

  final String label;
  final String description;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const OrderStatus({
    required this.label,
    required this.description,
    required this.color,
    required this.bgColor,
    required this.icon,
  });
}

class MinistrySupplyOrder {
  final String id;
  final String farmerName;
  final String nationalId;
  final String agriculturalCardNumber;
  final String landParcelNumber;
  final String landTitle;
  final String supplyName;
  final SupplyCategory category;
  final String requestedQuantity;
  final String approvedQuantity;
  final double subsidyPercentage;
  final double officialPriceLYD;
  final double farmerCostLYD;
  final OrderStatus status;
  final String pickupCooperative;
  final bool recommendedByAi;
  final String? aiRecommendationReason;
  final String voucherCode;
  final DateTime createdAt;

  MinistrySupplyOrder({
    required this.id,
    required this.farmerName,
    required this.nationalId,
    required this.agriculturalCardNumber,
    required this.landParcelNumber,
    required this.landTitle,
    required this.supplyName,
    required this.category,
    required this.requestedQuantity,
    required this.approvedQuantity,
    required this.subsidyPercentage,
    required this.officialPriceLYD,
    required this.farmerCostLYD,
    required this.status,
    required this.pickupCooperative,
    this.recommendedByAi = false,
    this.aiRecommendationReason,
    required this.voucherCode,
    required this.createdAt,
  });

  MinistrySupplyOrder copyWith({
    String? approvedQuantity,
    OrderStatus? status,
    String? pickupCooperative,
  }) {
    return MinistrySupplyOrder(
      id: id,
      farmerName: farmerName,
      nationalId: nationalId,
      agriculturalCardNumber: agriculturalCardNumber,
      landParcelNumber: landParcelNumber,
      landTitle: landTitle,
      supplyName: supplyName,
      category: category,
      requestedQuantity: requestedQuantity,
      approvedQuantity: approvedQuantity ?? this.approvedQuantity,
      subsidyPercentage: subsidyPercentage,
      officialPriceLYD: officialPriceLYD,
      farmerCostLYD: farmerCostLYD,
      status: status ?? this.status,
      pickupCooperative: pickupCooperative ?? this.pickupCooperative,
      recommendedByAi: recommendedByAi,
      aiRecommendationReason: aiRecommendationReason,
      voucherCode: voucherCode,
      createdAt: createdAt,
    );
  }
}
