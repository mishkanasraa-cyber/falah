import 'package:flutter/material.dart';

enum SupplyCategory {
  seeds(nameAr: 'بذور وشتلات معتمدة', icon: Icons.grass_rounded),
  fertilizers(nameAr: 'أسمدة ومغذيات زراعية', icon: Icons.science_rounded),
  pesticides(nameAr: 'مبيدات وقاية النبات', icon: Icons.pest_control_rounded),
  irrigation(nameAr: 'معدات وتقنيات الري', icon: Icons.water_drop_rounded);

  final String nameAr;
  final IconData icon;

  const SupplyCategory({required this.nameAr, required this.icon});
}

class AgriculturalSupply {
  final String id;
  final String name;
  final SupplyCategory category;
  final String description;
  final String targetCrops;
  final String dosageGuideline;
  final String libyanDistributor;
  final double subsidyPercentage;
  final bool isAvailableInCooperative;

  AgriculturalSupply({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.targetCrops,
    required this.dosageGuideline,
    required this.libyanDistributor,
    this.subsidyPercentage = 0.0,
    this.isAvailableInCooperative = true,
  });
}

class LibyanCropSeason {
  final String id;
  final String name;
  final String arabicName;
  final String seasonPeriod;
  final String bestSowingMonths;
  final String harvestMonths;
  final String irrigationNeeds;
  final String soilPreference;
  final List<String> primaryRegions;
  final String tips;

  LibyanCropSeason({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.seasonPeriod,
    required this.bestSowingMonths,
    required this.harvestMonths,
    required this.irrigationNeeds,
    required this.soilPreference,
    required this.primaryRegions,
    required this.tips,
  });
}
