import 'package:flutter/material.dart';

class AgriculturalWeatherStation {
  final String id;
  final String name;
  final String region;
  final double latitude;
  final double longitude;
  final bool isOperational;

  const AgriculturalWeatherStation({
    required this.id,
    required this.name,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.isOperational,
  });
}

class AgriculturalWeatherReading {
  final double temperatureC;
  final double humidityPercent;
  final double windSpeedKmH;
  final double soilMoisturePercent;
  final double evapotranspirationMm;
  final String conditionSummary;
  final String agriculturalAlert;
  final DateTime timestamp;

  AgriculturalWeatherReading({
    required this.temperatureC,
    required this.humidityPercent,
    required this.windSpeedKmH,
    required this.soilMoisturePercent,
    required this.evapotranspirationMm,
    required this.conditionSummary,
    required this.agriculturalAlert,
    required this.timestamp,
  });
}

class WeatherService extends ChangeNotifier {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  bool _isConnected = false;
  AgriculturalWeatherStation? _connectedStation;
  AgriculturalWeatherReading? _currentReading;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isConnected => _isConnected;
  AgriculturalWeatherStation? get connectedStation => _connectedStation;
  AgriculturalWeatherReading? get currentReading => _currentReading;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  static const List<AgriculturalWeatherStation> availableStations = [
    AgriculturalWeatherStation(
      id: 'STN-JAF-01',
      name: 'محطة الرصد الزراعي الميداني - سهل الجفارة والعزيزية',
      region: 'الجفارة',
      latitude: 32.5333,
      longitude: 13.0167,
      isOperational: true,
    ),
    AgriculturalWeatherStation(
      id: 'STN-MAJ-02',
      name: 'محطة حوض وادي المجينين وترهونة المناخية',
      region: 'ترهونة',
      latitude: 32.4350,
      longitude: 13.6330,
      isOperational: true,
    ),
    AgriculturalWeatherStation(
      id: 'STN-MIS-03',
      name: 'محطة زريق ومصراتة للرطوبة الساحلية',
      region: 'مصراتة',
      latitude: 32.3754,
      longitude: 15.0925,
      isOperational: true,
    ),
    AgriculturalWeatherStation(
      id: 'STN-JAB-04',
      name: 'محطة المرج والشحات للأمطار الجبلية',
      region: 'الجبل الأخضر',
      latitude: 32.7628,
      longitude: 21.8614,
      isOperational: true,
    ),
  ];

  Future<void> connectToStation(AgriculturalWeatherStation station) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate connecting to Libyan agro-meteorological station telemetry
    await Future.delayed(const Duration(milliseconds: 700));

    _isConnected = true;
    _connectedStation = station;
    _currentReading = AgriculturalWeatherReading(
      temperatureC: 22.4,
      humidityPercent: 58.0,
      windSpeedKmH: 14.2,
      soilMoisturePercent: 34.0,
      evapotranspirationMm: 3.1,
      conditionSummary: 'أجواء زراعية معتدلة مع رطوبة مناسبة للنمو',
      agriculturalAlert: 'ري خفيف موصى به لمحاصيل البطاطا والخضار في ساعات الصباح الباكر',
      timestamp: DateTime.now(),
    );

    _isLoading = false;
    notifyListeners();
  }

  void disconnectStation() {
    _isConnected = false;
    _connectedStation = null;
    _currentReading = null;
    notifyListeners();
  }

  Future<void> refreshTelemetry() async {
    if (!_isConnected || _connectedStation == null) return;
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _currentReading = AgriculturalWeatherReading(
      temperatureC: 23.1,
      humidityPercent: 54.0,
      windSpeedKmH: 16.0,
      soilMoisturePercent: 32.5,
      evapotranspirationMm: 3.4,
      conditionSummary: 'سماء صافية، رياح شمالية خفيفة',
      agriculturalAlert: 'ظروف مثالية للرش الوقائي لمركبات النحاس على أشجار الزيتون اليوم',
      timestamp: DateTime.now(),
    );

    _isLoading = false;
    notifyListeners();
  }
}
