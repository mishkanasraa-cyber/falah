import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../services/weather_service.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _weatherService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _weatherService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  void _showConnectDialog() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.forestDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.sensors_rounded, color: AppColors.limeBright, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ربط محطة رصد زراعية ليبية',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.forestDarkest),
                        ),
                        Text(
                          'اختر محطة الأرصاد الأقرب لمزرعتك لتلقي بيانات دقيقة',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              ...WeatherService.availableStations.map((station) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.limeLight,
                      child: Icon(Icons.satellite_alt_rounded, color: AppColors.limeDark, size: 20),
                    ),
                    title: Text(
                      station.name,
                      style: AppTypography.titleMedium.copyWith(fontSize: 14),
                    ),
                    subtitle: Text(
                      'المنطقة: ${station.region} • إحداثيات: ${station.latitude.toStringAsFixed(2)}°N, ${station.longitude.toStringAsFixed(2)}°E',
                      style: AppTypography.bodySmall,
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _weatherService.connectToStation(station);
                      },
                      child: const Text('اتصال'),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_weatherService.isConnected) {
      // Clearly labeled placeholder when not connected
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfacePure,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'بيانات الطقس الزراعي',
                            style: AppTypography.titleMedium.copyWith(color: AppColors.forestDarkest),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.statusDraftBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'غير متصل',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.statusDraft,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'لا يتم عرض قراءات مناخية افتراضية التزاماً بالمعايير الزراعية.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.warmBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.forestMedium),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'اربط محطة الأرصاد التابعة لمنطقتك لقراءة الرطوبة والري التنبؤي.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.forestDarkest),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      side: const BorderSide(color: AppColors.forestPrimary),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _showConnectDialog,
                    icon: const Icon(Icons.sensors_rounded, size: 16, color: AppColors.forestPrimary),
                    label: Text(
                      'ربط المحطة',
                      style: AppTypography.labelSmall.copyWith(color: AppColors.forestPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Connected State with real telemetry
    final reading = _weatherService.currentReading!;
    final station = _weatherService.connectedStation!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfacePure,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.limeBorder.withValues(alpha: 0.5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.forestPrimary.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Station Connection Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.limeLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.satellite_alt_rounded, color: AppColors.limeDark, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            station.name,
                            style: AppTypography.titleMedium.copyWith(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.statusApprovedBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'متصل ومباشر',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.statusApproved,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'تحديث قبل لحظات • ${station.region}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20, color: AppColors.forestMedium),
                onPressed: _weatherService.isLoading ? null : () => _weatherService.refreshTelemetry(),
                tooltip: 'تحديث القياسات',
              ),
              IconButton(
                icon: const Icon(Icons.link_off_rounded, size: 20, color: AppColors.statusAlert),
                onPressed: () => _weatherService.disconnectStation(),
                tooltip: 'قطع الاتصال',
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Telemetry Grid
          Row(
            children: [
              _buildTelemetryTile(
                icon: Icons.thermostat_rounded,
                label: 'حرارة الجو',
                value: '${reading.temperatureC}°C',
                color: const Color(0xFFEA580C),
              ),
              const SizedBox(width: 8),
              _buildTelemetryTile(
                icon: Icons.water_drop_rounded,
                label: 'الرطوبة النسبية',
                value: '${reading.humidityPercent}%',
                color: const Color(0xFF0284C7),
              ),
              const SizedBox(width: 8),
              _buildTelemetryTile(
                icon: Icons.air_rounded,
                label: 'سرعة الرياح',
                value: '${reading.windSpeedKmH} كم/س',
                color: const Color(0xFF0D9488),
              ),
              const SizedBox(width: 8),
              _buildTelemetryTile(
                icon: Icons.grass_rounded,
                label: 'رطوبة التربة',
                value: '${reading.soilMoisturePercent}%',
                color: AppColors.forestPrimary,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Station Advisory Banner
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates_rounded, color: AppColors.limeDark, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reading.agriculturalAlert,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.forestDarkest,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.surfaceBorder.withValues(alpha: 0.8)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTypography.titleMedium.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(fontSize: 9, color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
