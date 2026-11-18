import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import '../add_land/screen_21_add_land_owner_details.dart';

class Screen45RegisterOnBehalfOfFarmer extends StatelessWidget {
  final FarmerDirectoryItem targetFarmer;

  const Screen45RegisterOnBehalfOfFarmer({
    super.key,
    required this.targetFarmer,
  });

  void _startRegistration(BuildContext context) {
    final appState = AppState();

    if (appState.currentRole != UserRole.fieldSurveyor ||
        !targetFarmer.isAuthorizedForSurveyor) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يلزم دور موظف الحصر وتفويض المزارع لبدء التسجيل بالإنابة.',
          ),
        ),
      );
      return;
    }

    appState.resetDraft(
      isSurveyorOnBehalf: true,
      farmer: targetFarmer,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const Screen21AddLandOwnerDetails(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final canRegister =
            appState.currentRole == UserRole.fieldSurveyor &&
            targetFarmer.isAuthorizedForSurveyor;

        return Scaffold(
          backgroundColor: AppColors.warmBackground,
          appBar: AppBar(
            title: const Text('التسجيل بالإنابة'),
            backgroundColor: AppColors.forestDarkest,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'بيانات المزارع',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: Text(targetFarmer.fullName),
                        subtitle: Text(targetFarmer.municipality),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('الرقم الوطني'),
                        subtitle: Text(targetFarmer.nationalId),
                      ),
                      ListTile(
                        title: const Text('الهاتف'),
                        subtitle: Text(targetFarmer.phone),
                      ),
                      ListTile(
                        title: const Text('الأراضي المسجلة'),
                        trailing: Text(
                          '${targetFarmer.registeredLandsCount}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  targetFarmer.isAuthorizedForSurveyor
                      ? 'يوجد تفويض ضمن بيانات التطبيق التجريبية.'
                      : 'لا يوجد تفويض لهذا المزارع ضمن البيانات الحالية.',
                  style: TextStyle(
                    color: targetFarmer.isAuthorizedForSurveyor
                        ? AppColors.forestPrimary
                        : AppColors.statusAlert,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ستُنشأ مسودة جديدة باسم المزارع مع تسجيل '
                  'أن الإدخال تم بواسطة موظف الحصر.',
                  style: TextStyle(height: 1.7),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: canRegister
                      ? () => _startRegistration(context)
                      : null,
                  icon: const Icon(Icons.add_location_alt_outlined),
                  label: const Text('بدء تسجيل الأرض'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}