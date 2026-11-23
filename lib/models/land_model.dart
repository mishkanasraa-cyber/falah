import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

enum LandReviewStatus {
  approved(
    label: 'معتمد وموثق',
    description: 'تمت مطابقة الإحداثيات والوثائق بالسجل العقاري الزراعي',
    color: AppColors.statusApproved,
    bgColor: AppColors.statusApprovedBg,
    icon: Icons.verified_rounded,
  ),
  underReview(
    label: 'قيد المراجعة والتدقيق',
    description: 'بانتظار المعاينة الميدانية ومطابقة المخطط الهندسي',
    color: AppColors.statusReview,
    bgColor: AppColors.statusReviewBg,
    icon: Icons.hourglass_top_rounded,
  ),
  draft(
    label: 'مسودة قيد الاستكمال',
    description: 'يرجى استكمال رفع المرفقات والإحداثيات لإرسال الطلب',
    color: AppColors.statusDraft,
    bgColor: AppColors.statusDraftBg,
    icon: Icons.edit_note_rounded,
  );

  final String label;
  final String description;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const LandReviewStatus({
    required this.label,
    required this.description,
    required this.color,
    required this.bgColor,
    required this.icon,
  });
}

class GeoPoint {
  final double latitude;
  final double longitude;
  final String? label;

  const GeoPoint(this.latitude, this.longitude, [this.label]);
}

class LandRecord {
  final String id;
  final String parcelNumber;
  final String title;
  final String ownerName;
  final String nationalId;
  final String region;
  final String municipality;
  final double areaHectares;
  final double areaDunams;
  final List<String> crops;
  final String soilType;
  final String waterSource;
  final List<GeoPoint> boundaryPoints;
  final LandReviewStatus status;
  final List<String> photos;
  final List<String> documents;
  final String? reviewNotes;
  final DateTime createdAt;

  LandRecord({
    required this.id,
    required this.parcelNumber,
    required this.title,
    required this.ownerName,
    required this.nationalId,
    required this.region,
    required this.municipality,
    required this.areaHectares,
    required this.areaDunams,
    required this.crops,
    required this.soilType,
    required this.waterSource,
    required this.boundaryPoints,
    required this.status,
    required this.photos,
    required this.documents,
    this.reviewNotes,
    required this.createdAt,
  });

  LandRecord copyWith({
    String? parcelNumber,
    String? title,
    String? ownerName,
    String? nationalId,
    String? region,
    String? municipality,
    double? areaHectares,
    double? areaDunams,
    List<String>? crops,
    String? soilType,
    String? waterSource,
    List<GeoPoint>? boundaryPoints,
    LandReviewStatus? status,
    List<String>? photos,
    List<String>? documents,
    String? reviewNotes,
    DateTime? createdAt,
  }) {
    return LandRecord(
      id: id,
      parcelNumber: parcelNumber ?? this.parcelNumber,
      title: title ?? this.title,
      ownerName: ownerName ?? this.ownerName,
      nationalId: nationalId ?? this.nationalId,
      region: region ?? this.region,
      municipality: municipality ?? this.municipality,
      areaHectares: areaHectares ?? this.areaHectares,
      areaDunams: areaDunams ?? this.areaDunams,
      crops: crops ?? this.crops,
      soilType: soilType ?? this.soilType,
      waterSource: waterSource ?? this.waterSource,
      boundaryPoints: boundaryPoints ?? this.boundaryPoints,
      status: status ?? this.status,
      photos: photos ?? this.photos,
      documents: documents ?? this.documents,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
