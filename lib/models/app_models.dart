import 'package:flutter/material.dart';

enum UserRole {
  farmer(
    nameAr: 'مزارع',
    subtitleAr: 'توثيق الأراضي الخاصة ومتابعة المراجعات',
    badgeText: 'مزارع',
  ),
  fieldSurveyor(
    nameAr: 'موظف حصر زراعي',
    subtitleAr: 'حصر وتوثيق الأراضي نيابة عن المزارعين',
    badgeText: 'موظف حصر',
  ),
  inspector(
    nameAr: 'مهندس زراعي ومفتش',
    subtitleAr: 'معاينة الحدود وتدقيق السجلات الزراعية',
    badgeText: 'مفتش زراعي',
  ),
  cooperative(
    nameAr: 'مشرف جمعية زراعية',
    subtitleAr: 'متابعة المستلزمات والمعاملات الزراعية',
    badgeText: 'مشرف جمعية',
  );

  final String nameAr;
  final String subtitleAr;
  final String badgeText;

  const UserRole({
    required this.nameAr,
    required this.subtitleAr,
    required this.badgeText,
  });

  String get descriptionAr => subtitleAr;
}

enum LandReviewStatus {
  draft(
    label: 'مسودة',
    color: Color(0xFF64748B),
    bgColor: Color(0xFFF1F5F9),
    icon: Icons.edit_note_rounded,
  ),
  underReview(
    label: 'قيد المراجعة',
    color: Color(0xFFD97706),
    bgColor: Color(0xFFFEF3C7),
    icon: Icons.hourglass_top_rounded,
  ),
  requiresModification(
    label: 'يتطلب تعديلًا',
    color: Color(0xFFDC2626),
    bgColor: Color(0xFFFEE2E2),
    icon: Icons.warning_amber_rounded,
  ),
  approved(
    label: 'معتمد',
    color: Color(0xFF15803D),
    bgColor: Color(0xFFDCFCE7),
    icon: Icons.verified_rounded,
  );

  final String label;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const LandReviewStatus({
    required this.label,
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

class CropItem {
  final String id;
  final String cropType;
  final String season;
  final double cultivatedAreaHectares;
  final String? notes;

  CropItem({
    required this.id,
    required this.cropType,
    required this.season,
    required this.cultivatedAreaHectares,
    this.notes,
  });

  CropItem copyWith({
    String? cropType,
    String? season,
    double? cultivatedAreaHectares,
    String? notes,
  }) {
    return CropItem(
      id: id,
      cropType: cropType ?? this.cropType,
      season: season ?? this.season,
      cultivatedAreaHectares: cultivatedAreaHectares ?? this.cultivatedAreaHectares,
      notes: notes ?? this.notes,
    );
  }
}

class AttachmentItem {
  final String id;
  final String fileName;
  final String? caption;
  final bool isDocument;
  final bool isUploaded;
  final bool isUploading;
  final double uploadProgress;
  final String? uploadError;

  AttachmentItem({
    required this.id,
    required this.fileName,
    this.caption,
    this.isDocument = false,
    this.isUploaded = true,
    this.isUploading = false,
    this.uploadProgress = 1.0,
    this.uploadError,
  });

  AttachmentItem copyWith({
    String? fileName,
    String? caption,
    bool? isDocument,
    bool? isUploaded,
    bool? isUploading,
    double? uploadProgress,
    String? uploadError,
  }) {
    return AttachmentItem(
      id: id,
      fileName: fileName ?? this.fileName,
      caption: caption ?? this.caption,
      isDocument: isDocument ?? this.isDocument,
      isUploaded: isUploaded ?? this.isUploaded,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadError: uploadError ?? this.uploadError,
    );
  }
}

class ReviewTimelineStep {
  final String title;
  final String? date;
  final String description;
  final bool isDone;
  final bool isCurrent;
  final bool isError;

  const ReviewTimelineStep({
    required this.title,
    this.date,
    required this.description,
    this.isDone = false,
    this.isCurrent = false,
    this.isError = false,
  });
}

class LandRecord {
  final String id;
  final String recordNumber;
  final String landName;
  final String ownerName;
  final String ownerNationalId;
  final String ownerPhone;
  final String? enteredBySurveyorName;
  final String? surveyorId;
  final bool isEnteredOnBehalf;
  final String municipality;
  final String locationName;
  final String soilType;
  final String waterSource;
  final String? reviewNotes;
  final double latitude;
  final double longitude;
  final List<GeoPoint> boundaryPoints;
  final double estimatedAreaHectares;
  final double estimatedAreaDunams;
  final List<CropItem> crops;
  final List<AttachmentItem> attachments;
  final LandReviewStatus status;
  final List<ReviewTimelineStep> reviewTimeline;
  final String? returnReason;
  final List<String> affectedFields;
  final bool isDraft;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  LandRecord({
    required this.id,
    required this.recordNumber,
    required this.landName,
    required this.ownerName,
    required this.ownerNationalId,
    required this.ownerPhone,
    this.enteredBySurveyorName,
    this.surveyorId,
    this.isEnteredOnBehalf = false,
    required this.municipality,
    required this.locationName,
    this.soilType = '',
    this.waterSource = '',
    this.reviewNotes,
    required this.latitude,
    required this.longitude,
    required this.boundaryPoints,
    required this.estimatedAreaHectares,
    required this.estimatedAreaDunams,
    required this.crops,
    required this.attachments,
    required this.status,
    required this.reviewTimeline,
    this.returnReason,
    this.affectedFields = const [],
    this.isDraft = false,
    this.isSynced = true,
    required this.createdAt,
    required this.updatedAt,
  });

  LandRecord copyWith({
    String? recordNumber,
    String? landName,
    String? ownerName,
    String? ownerNationalId,
    String? ownerPhone,
    String? enteredBySurveyorName,
    String? surveyorId,
    bool? isEnteredOnBehalf,
    String? municipality,
    String? locationName,
    String? soilType,
    String? waterSource,
    String? reviewNotes,
    double? latitude,
    double? longitude,
    List<GeoPoint>? boundaryPoints,
    double? estimatedAreaHectares,
    double? estimatedAreaDunams,
    List<CropItem>? crops,
    List<AttachmentItem>? attachments,
    LandReviewStatus? status,
    List<ReviewTimelineStep>? reviewTimeline,
    String? returnReason,
    List<String>? affectedFields,
    bool? isDraft,
    bool? isSynced,
    DateTime? updatedAt,
  }) {
    return LandRecord(
      id: id,
      recordNumber: recordNumber ?? this.recordNumber,
      landName: landName ?? this.landName,
      ownerName: ownerName ?? this.ownerName,
      ownerNationalId: ownerNationalId ?? this.ownerNationalId,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      enteredBySurveyorName: enteredBySurveyorName ?? this.enteredBySurveyorName,
      surveyorId: surveyorId ?? this.surveyorId,
      isEnteredOnBehalf: isEnteredOnBehalf ?? this.isEnteredOnBehalf,
      municipality: municipality ?? this.municipality,
      locationName: locationName ?? this.locationName,
      soilType: soilType ?? this.soilType,
      waterSource: waterSource ?? this.waterSource,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      boundaryPoints: boundaryPoints ?? this.boundaryPoints,
      estimatedAreaHectares: estimatedAreaHectares ?? this.estimatedAreaHectares,
      estimatedAreaDunams: estimatedAreaDunams ?? this.estimatedAreaDunams,
      crops: crops ?? this.crops,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      reviewTimeline: reviewTimeline ?? this.reviewTimeline,
      returnReason: returnReason ?? this.returnReason,
      affectedFields: affectedFields ?? this.affectedFields,
      isDraft: isDraft ?? this.isDraft,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class FarmerDirectoryItem {
  final String id;
  final String fullName;
  final String nationalId;
  final String phone;
  final String municipality;
  final int registeredLandsCount;
  final bool isAuthorizedForSurveyor;

  const FarmerDirectoryItem({
    required this.id,
    required this.fullName,
    required this.nationalId,
    required this.phone,
    required this.municipality,
    required this.registeredLandsCount,
    required this.isAuthorizedForSurveyor,
  });
}

enum SupplyType { seeds, fertilizers }

class SupplyCatalogProduct {
  final String id;
  final String name;
  final SupplyType type;
  final String categoryName;
  final String description;
  final String suitableCrops;
  final String seasonRecommendation;
  final bool isSampleDemoData;
  bool isFavorite;

  SupplyCatalogProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.categoryName,
    required this.description,
    required this.suitableCrops,
    required this.seasonRecommendation,
    this.isSampleDemoData = true,
    this.isFavorite = false,
  });
}

class AppNotificationItem {
  final String id;
  final String title;
  final String body;
  final String dateCategory; // 'اليوم', 'أمس', 'الأسبوع الماضي'
  final DateTime timestamp;
  final String? relatedRecordId;
  final LandReviewStatus? statusType;
  bool isRead;

  AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.dateCategory,
    required this.timestamp,
    this.relatedRecordId,
    this.statusType,
    this.isRead = false,
  });
}
