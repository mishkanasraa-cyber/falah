import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/app_models.dart';
import '../../services/app_state.dart';
import 'screen_20_land_record_details.dart';

class Screen19SearchFilterLands extends StatefulWidget {
  const Screen19SearchFilterLands({super.key});

  @override
  State<Screen19SearchFilterLands> createState() => _Screen19SearchFilterLandsState();
}

class _Screen19SearchFilterLandsState extends State<Screen19SearchFilterLands> {
  final AppState _appState = AppState();
  final _searchController = TextEditingController();

  String _searchQuery = '';
  LandReviewStatus? _selectedStatus;
  String? _selectedMunicipality;
  String _selectedDateFilter = 'الكل';

  final List<String> _municipalities = [
    'الكل',
    'ترهونة',
    'السواني بن آدم',
    'مصراتة',
    'العزيزية',
    'سيدي السائح',
  ];

  final List<String> _dateOptions = [
    'الكل',
    'خلال الشهر الأخير',
    'خلال آخر 3 أشهر',
    'خلال عام 2027',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LandRecord> get _filteredResults {
    return _appState.lands.where((l) {
      final matchesQuery = _searchQuery.isEmpty ||
          l.landName.contains(_searchQuery) ||
          l.recordNumber.contains(_searchQuery) ||
          l.ownerName.contains(_searchQuery) ||
          l.municipality.contains(_searchQuery);

      final matchesStatus = _selectedStatus == null || l.status == _selectedStatus;

      final matchesMun = _selectedMunicipality == null ||
          _selectedMunicipality == 'الكل' ||
          l.municipality.contains(_selectedMunicipality!);

      return matchesQuery && matchesStatus && matchesMun;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedStatus = null;
      _selectedMunicipality = null;
      _selectedDateFilter = 'الكل';
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredResults;

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        title: const Text('البحث والفلترة المتقدمة'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text('إعادة ضبط', style: AppTypography.labelSmall.copyWith(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Box & Filters Header
          Container(
            color: AppColors.surfacePure,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم الأرض، رقم السجل، أو المالك...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.forestPrimary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Municipality & Status Filter Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedMunicipality ?? 'الكل',
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'البلدية',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _municipalities.map((m) {
                          return DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 12)));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedMunicipality = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedDateFilter,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'تاريخ التسجيل',
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _dateOptions.map((d) {
                          return DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 12)));
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedDateFilter = val ?? 'الكل'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        selected: _selectedStatus == null,
                        label: const Text('كل الحالات'),
                        onSelected: (_) => setState(() => _selectedStatus = null),
                      ),
                      const SizedBox(width: 6),
                      ...LandReviewStatus.values.map((status) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: FilterChip(
                            selected: _selectedStatus == status,
                            label: Text(status.label),
                            selectedColor: status.bgColor,
                            onSelected: (_) => setState(() => _selectedStatus = status),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Results Counter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  'نتائج البحث المطابقة (${results.length}):',
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text('لا توجد سجلات مطابقة للبحث', style: AppTypography.titleMedium),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final land = results[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppColors.surfaceBorder),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: land.status.bgColor,
                            child: Icon(land.status.icon, color: land.status.color, size: 20),
                          ),
                          title: Text(
                            land.landName,
                            style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'المالك: ${land.ownerName} • ${land.municipality} • (${land.recordNumber})',
                            style: AppTypography.bodySmall.copyWith(fontSize: 10),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: () {
                            _appState.setSelectedRecord(land);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Screen20LandRecordDetails(record: land)),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
