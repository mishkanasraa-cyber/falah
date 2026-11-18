import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';

class Screen46AgriculturalSuppliesCatalog extends StatefulWidget {
  const Screen46AgriculturalSuppliesCatalog({super.key});

  @override
  State<Screen46AgriculturalSuppliesCatalog> createState() =>
      _Screen46AgriculturalSuppliesCatalogState();
}

class _Screen46AgriculturalSuppliesCatalogState
    extends State<Screen46AgriculturalSuppliesCatalog> {
  final AppState _appState = AppState();
  String _searchText = '';
  bool _favoritesOnly = false;

  void _showProductDetails(SupplyCatalogProduct product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.forestDarkest,
                  ),
                ),
                const SizedBox(height: 8),
                Text(product.categoryName),
                const SizedBox(height: 20),
                const Text(
                  'الوصف',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(product.description, style: const TextStyle(height: 1.6)),
                const SizedBox(height: 16),
                const Text(
                  'المحاصيل المناسبة',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(product.suitableCrops),
                const SizedBox(height: 16),
                const Text(
                  'الموسم الموصى به',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(product.seasonRecommendation),
                if (product.isSampleDemoData) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'بيانات تجريبية للعرض ضمن المشروع.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('إغلاق'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('دليل المستلزمات الزراعية'),
        backgroundColor: AppColors.forestDarkest,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'ابحث عن مستلزم أو محصول...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value.trim().toLowerCase();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('المفضلة فقط'),
                    selected: _favoritesOnly,
                    avatar: Icon(
                      _favoritesOnly
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _favoritesOnly = selected;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: AnimatedBuilder(
                animation: _appState,
                builder: (context, child) {
                  final products = _appState.supplies.where((product) {
                    final matchesSearch = [
                      product.name,
                      product.categoryName,
                      product.suitableCrops,
                    ].any((text) => text.toLowerCase().contains(_searchText));

                    final matchesFavorites =
                        !_favoritesOnly || product.isFavorite;

                    return matchesSearch && matchesFavorites;
                  }).toList();

                  if (products.isEmpty) {
                    return const Center(
                      child: Text('لا توجد مستلزمات تطابق اختيارك.'),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.limeLight,
                            child: Icon(
                              Icons.grass_rounded,
                              color: AppColors.forestPrimary,
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${product.categoryName}\n'
                              '${product.suitableCrops}',
                            ),
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            tooltip: product.isFavorite
                                ? 'إزالة من المفضلة'
                                : 'إضافة إلى المفضلة',
                            icon: Icon(
                              product.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: product.isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _appState.toggleFavoriteSupply(product.id);
                            },
                          ),
                          onTap: () => _showProductDetails(product),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
