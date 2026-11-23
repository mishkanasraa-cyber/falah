import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';

class Screen47SeedsCatalog extends StatelessWidget {
  const Screen47SeedsCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final seeds = appState.supplies
            .where((product) => product.type == SupplyType.seeds)
            .toList();

        return Scaffold(
          backgroundColor: AppColors.warmBackground,
          appBar: AppBar(
            title: const Text('دليل البذور'),
            backgroundColor: AppColors.forestDarkest,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: seeds.isEmpty
                ? const Center(child: Text('لا توجد بذور في الدليل حاليًا.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: seeds.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = seeds[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.grass_rounded,
                                    color: AppColors.forestPrimary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: product.isFavorite
                                        ? 'إزالة من المفضلة'
                                        : 'إضافة إلى المفضلة',
                                    icon: Icon(
                                      product.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: product.isFavorite
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      appState.toggleFavoriteSupply(product.id);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.description,
                                style: const TextStyle(height: 1.6),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'المحاصيل المناسبة: '
                                '${product.suitableCrops}',
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'الموسم الموصى به: '
                                '${product.seasonRecommendation}',
                              ),
                              if (product.isSampleDemoData) ...[
                                const SizedBox(height: 12),
                                const Text(
                                  'بيانات تجريبية للعرض ضمن المشروع.',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
