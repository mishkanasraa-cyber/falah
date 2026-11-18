import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import 'screen_45_register_on_behalf_of_farmer.dart';

class Screen43SearchForFarmer extends StatefulWidget {
  const Screen43SearchForFarmer({super.key});

  @override
  State<Screen43SearchForFarmer> createState() =>
      _Screen43SearchForFarmerState();
}

class _Screen43SearchForFarmerState extends State<Screen43SearchForFarmer> {
  final AppState _appState = AppState();
  String _query = '';

  void _selectFarmer(FarmerDirectoryItem farmer) {
    if (_appState.currentRole != UserRole.fieldSurveyor ||
        !farmer.isAuthorizedForSurveyor) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('التسجيل يحتاج موظف حصر وتفويضًا من المزارع.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => Screen45RegisterOnBehalfOfFarmer(targetFarmer: farmer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, child) {
        final isSurveyor = _appState.currentRole == UserRole.fieldSurveyor;

        final farmers = _appState.farmersDirectory.where((farmer) {
          return [
            farmer.fullName,
            farmer.nationalId,
            farmer.phone,
            farmer.municipality,
          ].any((value) => value.toLowerCase().contains(_query));
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.warmBackground,
          appBar: AppBar(
            title: const Text('البحث عن مزارع'),
            backgroundColor: AppColors.forestDarkest,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: !isSurveyor
                ? const Center(
                    child: Text('هذه الصفحة مخصصة لموظف الحصر الزراعي.'),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'اسم المزارع أو الرقم الوطني أو الهاتف',
                            prefixIcon: Icon(Icons.search_rounded),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _query = value.trim().toLowerCase();
                            });
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'البحث حاليًا في دليل المزارعين التجريبي داخل التطبيق.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: farmers.isEmpty
                            ? const Center(
                                child: Text('لا يوجد مزارعون مطابقون للبحث.'),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: farmers.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final farmer = farmers[index];

                                  return Card(
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.person_outline_rounded,
                                      ),
                                      title: Text(farmer.fullName),
                                      subtitle: Text(
                                        '${farmer.municipality}\n'
                                        'أراضٍ مسجلة: '
                                        '${farmer.registeredLandsCount}\n'
                                        '${farmer.isAuthorizedForSurveyor ? "مفوّض للتسجيل" : "بدون تفويض"}',
                                      ),
                                      isThreeLine: true,
                                      trailing: Icon(
                                        farmer.isAuthorizedForSurveyor
                                            ? Icons.chevron_left_rounded
                                            : Icons.lock_outline_rounded,
                                      ),
                                      onTap: () => _selectFarmer(farmer),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
