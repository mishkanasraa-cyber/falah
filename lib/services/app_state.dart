import 'package:flutter/material.dart';

import '../models/user_role.dart' show UserProfile;
import '../models/app_models.dart';
import '../models/ai_diagnosis_model.dart';
import '../models/ministry_order_model.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    _initSampleData();
  }

  // Active Role and User
  UserRole _currentRole = UserRole.farmer;
  UserRole get currentRole => _currentRole;

  String _userName = 'عمر البشير المريمي';
  String _userPhone = '+218 91 234 5678';
  String _userNationalId = '119850239481';
  String _userMunicipality = 'ترهونة';

  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userNationalId => _userNationalId;
  String get userMunicipality => _userMunicipality;

  UserProfile get currentUser {
    final nameParts = _userName.trim().split(RegExp(r'\s+'));

    final initials = nameParts
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => String.fromCharCode(part.runes.first))
        .join();

    return UserProfile(
      id: 'local-session-user',
      fullName: _userName,
      nationalId: _userNationalId,
      agriculturalCardNumber: '',
      phone: _userPhone,
      city: _userMunicipality,
      role: _currentRole,
      avatarInitials: initials.isEmpty ? '؟' : initials,
    );
  }

  // Selected bottom navigation index (0: الرئيسية, 1: الأراضي, 2: الخدمات, 3: الإشعارات, 4: حسابي)
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    if (index >= 0 && index <= 4) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void switchRole(UserRole role) {
    if (_currentRole == role) {
      return;
    }

    _currentRole = role;
    notifyListeners();
  }

  void setCustomUserData({
    required String name,
    required String phone,
    required String nationalId,
    required String municipality,
  }) {
    _userName = name;
    _userPhone = phone;
    _userNationalId = nationalId;
    _userMunicipality = municipality;
    notifyListeners();
  }

  // طلبات المستلزمات في ذاكرة التطبيق.
  final List<MinistrySupplyOrder> _ministryOrders = [];

  List<MinistrySupplyOrder> get ministryOrders =>
      List.unmodifiable(_ministryOrders);

  // حفظ طلب جديد محليًا.
  void submitMinistryOrder(MinistrySupplyOrder order) {
    final alreadyExists = _ministryOrders.any((item) => item.id == order.id);

    if (alreadyExists) {
      return;
    }

    _ministryOrders.insert(0, order);
    notifyListeners();
  }

  // اعتماد تجريبي للطلب من واجهة الجمعية.
  void approveMinistryOrder(String orderId) {
    if (_currentRole != UserRole.cooperative) {
      return;
    }

    final index = _ministryOrders.indexWhere((item) => item.id == orderId);

    if (index == -1) {
      return;
    }

    final order = _ministryOrders[index];

    if (order.status != OrderStatus.underReview) {
      return;
    }

    _ministryOrders[index] = order.copyWith(
      approvedQuantity: order.requestedQuantity,
      status: OrderStatus.approvedReadyForPickup,
    );

    notifyListeners();
  }

  // Lands Repository
  late List<LandRecord> _lands;
  List<LandRecord> get lands => List.unmodifiable(_lands);

  // حفظ سجل من النموذج الموحد داخل ذاكرة التطبيق.
  void addLand(LandRecord land) {
    if (_lands.any((item) => item.id == land.id)) return;
    _lands.insert(0, land);
    _selectedRecord = land;
    if (land.isDraft) _activeDraft = land;
    notifyListeners();
  }

  bool saveLandAttachments(String id, List<AttachmentItem> attachments) {
    final index = _lands.indexWhere((item) => item.id == id);
    if (index == -1) return false;
    final land = _lands[index];
    if (land.status != LandReviewStatus.draft &&
        land.status != LandReviewStatus.requiresModification) {
      return false;
    }
    final updated = land.copyWith(attachments: attachments,
      updatedAt: DateTime.now(), isSynced: false);
    _lands[index] = updated;
    if (_selectedRecord?.id == id) _selectedRecord = updated;
    if (_activeDraft.id == id) _activeDraft = updated;
    notifyListeners();
    return true;
  }

  bool updateLandStatus(String id, LandReviewStatus status, String notes) {
    if (_currentRole != UserRole.inspector) return false;
    final index = _lands.indexWhere((item) => item.id == id);
    if (index == -1 || _lands[index].status != LandReviewStatus.underReview) return false;
    if (status != LandReviewStatus.approved &&
        status != LandReviewStatus.requiresModification) {
      return false;
    }
    if (status == LandReviewStatus.requiresModification && notes.trim().isEmpty) return false;
    final land = _lands[index];
    final updated = land.copyWith(status: status, reviewNotes: notes.trim(),
      returnReason: status == LandReviewStatus.requiresModification ? notes.trim() : '',
      isDraft: false, isSynced: false, updatedAt: DateTime.now(),
      reviewTimeline: [...land.reviewTimeline,
        ReviewTimelineStep(title: status.label, description: notes.trim(),
          date: DateTime.now().toIso8601String(), isDone: true)]);
    _lands[index] = updated;
    if (_selectedRecord?.id == id) _selectedRecord = updated;
    notifyListeners();
    return true;
  }

  LandRecord? _selectedRecord;
  LandRecord? get selectedRecord => _selectedRecord;
  void setSelectedRecord(LandRecord record) {
    _selectedRecord = record;
    notifyListeners();
  }

    bool addCropToLand(String landId, CropItem crop) {
    final index = _lands.indexWhere((land) => land.id == landId);

    if (index == -1) {
      return false;
    }

    final land = _lands[index];

    // تعديل السجلات القابلة للتحرير فقط.
    if (land.status != LandReviewStatus.draft &&
        land.status != LandReviewStatus.requiresModification) {
      return false;
    }

    final updated = land.copyWith(
      crops: [...land.crops, crop],
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    _lands[index] = updated;

    if (_selectedRecord?.id == landId) {
      _selectedRecord = updated;
    }

    if (_activeDraft.id == landId) {
      _activeDraft = updated;
    }

    notifyListeners();
    return true;
  }
  // Active Land Registration Wizard Draft
  late LandRecord _activeDraft;
  LandRecord get activeDraft => _activeDraft;

  void resetDraft({
    bool isSurveyorOnBehalf = false,
    FarmerDirectoryItem? farmer,
  }) {
    _activeDraft = LandRecord(
      id: 'DRAFT-${DateTime.now().millisecondsSinceEpoch}',
      recordNumber: 'LY-2027-${DateTime.now().millisecondsSinceEpoch % 10000}',
      landName: '',
      ownerName: isSurveyorOnBehalf && farmer != null
          ? farmer.fullName
          : _userName,
      ownerNationalId: isSurveyorOnBehalf && farmer != null
          ? farmer.nationalId
          : _userNationalId,
      ownerPhone: isSurveyorOnBehalf && farmer != null
          ? farmer.phone
          : _userPhone,
      enteredBySurveyorName: isSurveyorOnBehalf ? _userName : null,
      surveyorId: isSurveyorOnBehalf ? 'SURV-784' : null,
      isEnteredOnBehalf: isSurveyorOnBehalf,
      municipality: isSurveyorOnBehalf && farmer != null
          ? farmer.municipality
          : _userMunicipality,
      locationName: '',
      latitude: 32.4350,
      longitude: 13.6330,
      boundaryPoints: [],
      estimatedAreaHectares: 0.0,
      estimatedAreaDunams: 0.0,
      crops: [],
      attachments: [],
      status: LandReviewStatus.draft,
      reviewTimeline: [
        ReviewTimelineStep(
          title: 'إنشاء المسودة',
          date: 'اليوم',
          description: 'بدء توثيق الحيازة الزراعية على التطبيق',
          isDone: true,
          isCurrent: true,
        ),
      ],
      isDraft: true,
      isSynced: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void updateDraft({
    String? landName,
    String? ownerName,
    String? ownerNationalId,
    String? ownerPhone,
    String? municipality,
    String? locationName,
    double? latitude,
    double? longitude,
    List<GeoPoint>? boundaryPoints,
    double? estimatedAreaHectares,
    double? estimatedAreaDunams,
    List<CropItem>? crops,
    List<AttachmentItem>? attachments,
    bool? isDraft,
    bool? isSynced,
  }) {
    _activeDraft = _activeDraft.copyWith(
      landName: landName,
      ownerName: ownerName,
      ownerNationalId: ownerNationalId,
      ownerPhone: ownerPhone,
      municipality: municipality,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      boundaryPoints: boundaryPoints,
      estimatedAreaHectares: estimatedAreaHectares,
      estimatedAreaDunams: estimatedAreaDunams,
      crops: crops,
      attachments: attachments,
      isDraft: isDraft,
      isSynced: isSynced,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void saveCurrentDraftToRecords() {
    final existingIndex = _lands.indexWhere((l) => l.id == _activeDraft.id);
    if (existingIndex != -1) {
      _lands[existingIndex] = _activeDraft.copyWith(
        isDraft: true,
        status: LandReviewStatus.draft,
      );
    } else {
      _lands.insert(
        0,
        _activeDraft.copyWith(isDraft: true, status: LandReviewStatus.draft),
      );
    }
    notifyListeners();
  }

  void submitCurrentDraftForReview() {
    final timeline = [
      ReviewTimelineStep(
        title: 'تم تقديم الطلب',
        date: 'اليوم',
        description:
            'تم إرسال الملف إلى منصة جُذور (Juthoor) للمراجعة الإدارية والفنية',
        isDone: true,
      ),
      ReviewTimelineStep(
        title: 'المراجعة والتدقيق الفني',
        date: 'قيد الإجراء',
        description:
            'فحص المخطط الجغرافي والحدود ومطابقة الحيازة مع قاعدة البيانات',
        isDone: false,
        isCurrent: true,
      ),
      ReviewTimelineStep(
        title: 'المصادقة والاعتماد النهائي',
        date: 'بانتظار الاكتمال',
        description: 'إصدار شهادة الحصر الزراعي المعتمدة رسمياً',
        isDone: false,
      ),
    ];

    final submitted = _activeDraft.copyWith(
      status: LandReviewStatus.underReview,
      isDraft: false,
      isSynced: true,
      reviewTimeline: timeline,
      updatedAt: DateTime.now(),
    );

    final existingIndex = _lands.indexWhere((l) => l.id == submitted.id);
    if (existingIndex != -1) {
      _lands[existingIndex] = submitted;
    } else {
      _lands.insert(0, submitted);
    }

    _selectedRecord = submitted;

    // Add notification
    _notifications.insert(
      0,
      AppNotificationItem(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
        title: 'تم إرسال ملف الأرض للمراجعة',
        body:
            'أرض "${submitted.landName}" برقم (${submitted.recordNumber}) أحيلت للمراجعة عبر منصة جُذور.',
        dateCategory: 'اليوم',
        timestamp: DateTime.now(),
        relatedRecordId: submitted.id,
        statusType: LandReviewStatus.underReview,
      ),
    );

    notifyListeners();
  }

  void resubmitReturnedRecord(LandRecord correctedRecord) {
    final updatedTimeline =
        List<ReviewTimelineStep>.from(correctedRecord.reviewTimeline)..add(
          ReviewTimelineStep(
            title: 'إعادة الإرسال بعد التعديل',
            date: 'اليوم',
            description:
                'تم تحديث البيانات والمخطط وإعادة الإرسال للمراجع في جُذور',
            isDone: true,
            isCurrent: true,
          ),
        );

    final updated = correctedRecord.copyWith(
      status: LandReviewStatus.underReview,
      returnReason: null,
      affectedFields: [],
      reviewTimeline: updatedTimeline,
      updatedAt: DateTime.now(),
    );

    final index = _lands.indexWhere((l) => l.id == updated.id);
    if (index != -1) {
      _lands[index] = updated;
    }
    _selectedRecord = updated;
    notifyListeners();
  }

  // Farmer Directory for Field Surveyor Search
  late List<FarmerDirectoryItem> _farmersDirectory;
  List<FarmerDirectoryItem> get farmersDirectory =>
      List.unmodifiable(_farmersDirectory);

  // Fictional Samples Catalog (Seeds & Fertilizers)
  late List<SupplyCatalogProduct> _supplies;
  List<SupplyCatalogProduct> get supplies => List.unmodifiable(_supplies);

  void toggleFavoriteSupply(String id) {
    final index = _supplies.indexWhere((s) => s.id == id);
    if (index != -1) {
      _supplies[index].isFavorite = !_supplies[index].isFavorite;
      notifyListeners();
    }
  }

  // Notifications
  late List<AppNotificationItem> _notifications;

  List<AppNotificationItem> get notifications =>
      List.unmodifiable(_notifications);

  // عدد الإشعارات غير المقروءة.
  int get unreadNotificationsCount {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere(
      (notification) => notification.id == id,
    );

    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (final notification in _notifications) {
      notification.isRead = true;
    }

    notifyListeners();
  }

  // Weather Connection state (Strictly honest placeholder unless connected)
  bool _isWeatherConnected = false;
  bool get isWeatherConnected => _isWeatherConnected;

  void toggleWeatherConnection() {
    _isWeatherConnected = !_isWeatherConnected;
    notifyListeners();
  }

  // Offline drafts & synchronization state
  bool _isOnline = true;
  bool get isOnline => _isOnline;
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  void toggleOnlineState() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  Future<void> syncOfflineDrafts() async {
    if (!_isOnline) return;
    _isSyncing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    for (int i = 0; i < _lands.length; i++) {
      if (!_lands[i].isSynced) {
        _lands[i] = _lands[i].copyWith(isSynced: true);
      }
    }
    _isSyncing = false;
    notifyListeners();
  }

  // AI Assistant Chat Messages & State
  final List<Map<String, dynamic>> _aiMessages = [
    {
      'isUser': false,
      'text': 'مرحباً بك في **مساعد فلاح الذكي** 🌿\n\nأنا مرشدك الإجرائي والتقني داخل التطبيق. يمكنني توضيح خطوات توثيق الأرض، رسم الحدود، وشرح معاني حالات المراجعة في منصة جُذور.\n\nكيف يمكنني مساعدتك اليوم؟',
      'time': 'الآن',
    },
  ];
  List<Map<String, dynamic>> get aiMessages => List.unmodifiable(_aiMessages);
  final DateTime _chatSessionStartedAt = DateTime.now();

  List<ChatMessage> get chatHistory {
    return List<ChatMessage>.unmodifiable(
      _aiMessages.asMap().entries.map((entry) {
        final data = entry.value;

        return ChatMessage(
          id: 'chat-${entry.key}',
          text: data['text'] as String? ?? '',
          isUser: data['isUser'] == true,
          timestamp: data['timestamp'] is DateTime
              ? data['timestamp'] as DateTime
              : _chatSessionStartedAt,
        );
      }),
    );
  }

  Future<void> sendChatMessage(String text) async {
    final prompt = text.trim();

    if (prompt.isEmpty || _aiIsTyping) {
      return;
    }

    await sendAiMessage(prompt);
  }

  bool _aiIsTyping = false;
  bool get aiIsTyping => _aiIsTyping;

  Future<void> sendAiMessage(String prompt) async {
    _aiMessages.add({'isUser': true, 'text': prompt, 'time': 'الآن'});
    _aiIsTyping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 700));

    String reply = '';
    final p = prompt.toLowerCase();
    if (p.contains('كيف نضيف أرض') ||
        p.contains('إضافة أرض') ||
        p.contains('تسجيل أرض')) {
      reply = '''
📋 **خطوات إضافة وتوثيق أرض جديدة في فلاح:**
1. اضغط على زر **"إضافة أرض"** في الشاشة الرئيسية أو قسم الأراضي.
2. أدخل بيانات المالك والبلدية بدقة مع إرفاق الرقم الوطني.
3. اختر طريقة تحديد الموقع: عبر نظام GPS الميداني أو بالنقر المباشر على الخريطة.
4. ارسم مضلع الحدود بالضغط على زوايا الأرض، وراجع المساحة المحسوبة تقريبياً.
5. أضف المحاصيل القائمة في الحقل ومواسم زراعتها.
6. ارفق المستندات والوثائق الثبوتية وصور المعالم من الحقل.
7. راجع الملخص واحفظ كمسودة أو أرسل للمراجعة والتدقيق عبر منصة جُذور.
''';
    } else if (p.contains('حدود') || p.contains('رسم') || p.contains('خريطة')) {
      reply = '''
🗺️ **إرشادات تحديد ورسم حدود الأرض:**
• يرجى الوقوف أو التأشير عند أركان الحقل الرئيسية (3 نقاط على الأقل لتكوين مضلع مغلق).
• يمكنك استخدام أزرار **"تراجع"** لإلغاء آخر نقطة أو **"مسح الكل"** للبدء من جديد.
• ⚠️ **تنبيه هام:** المساحة المعروضة في التطبيق هي **تقدير حسابي مبدئي** معتمد على النقاط المحددة وليست مسحاً عقارياً نهائياً.
''';
    } else if (p.contains('قيد المراجعة') ||
        p.contains('معنى') ||
        p.contains('حالة')) {
      reply = '''
📌 **معاني حالات السجل في فلاح:**
• **مسودة:** الملف محفوظ محلياً على هاتفك ولم يُرسل بعد.
• **قيد المراجعة:** تم استلام الملف في منصة جُذور (Juthoor) وهو تحت التدقيق الفني والمطابقة المكانية.
• **يتطلب تعديلًا:** أعاد المراجع الملف مع ملاحظات محددة (مثل إعادة رسم حد أو رفع وثيقة واضحة).
• **معتمد:** اكتملت المراجعة والمطابقة وصدرت الموافقة الرسمية للحيازة.
''';
    } else if (p.contains('نعدل') ||
        p.contains('تعديل') ||
        p.contains('ملاحظات')) {
      reply = '''
✏️ **كيفية تعديل الطلب المرتجع:**
1. افتح الطلب المعلم بحالة **"يتطلب تعديلًا"** من قائمة أراضيك.
2. اقرأ سبب الإرجاع المكتوب في شاشة الشرح والحقول المتأثرة.
3. اضغط على **"تعديل السجل"** حيث ستجد بياناتك السابقة محفوظة مع إبراز الحقول المطلوب تصحيحها.
4. قم بإجراء التعديل ثم اضغط **"إعادة الإرسال للمراجعة"**.
''';
    } else if (p.contains('منتج') ||
        p.contains('بذور') ||
        p.contains('أسمدة') ||
        p.contains('مستلزمات')) {
      reply = '''
📦 **معلومات المستلزمات الزراعية في التطبيق:**
• الأصناف المعروضة في قسم المستلزمات هي **بيانات توضيحية تجريبية** للمعاينة ضمن النموذج الأولي.
• لا يحتوي التطبيق على خدمات شراء إلكتروني أو شحن؛ يمكنك استخدام زر "طلب معلومات" للاستفسار عن توفر الأصناف المعتمدة في منطقتك.
''';
    } else {
      reply = '''
أهلاً بك، بصفتي مساعد فلاح الذكي يمكنني إرشادك في:
• خطوات توثيق الأرض ومطابقة الحيازات.
• كيفية رسم مضلع الحدود وحساب المساحة التقديرية.
• متابعة الحالات وفهم ملاحظات مراجعي منصة جُذور.
• تصفح دليل الخدمات والمستلزمات الزراعية.

اطرح سؤالك بوضوح وسأشرح لك الخطوات بالتفصيل!
''';
    }

    _aiMessages.add({'isUser': false, 'text': reply, 'time': 'الآن'});
    _aiIsTyping = false;
    notifyListeners();
  }

  void _initSampleData() {
    _lands = [
      LandRecord(
        id: 'LND-2027-001',
        recordNumber: 'LY-TRH-2027-014',
        landName: 'مزرعة وادي المجينين - الزيتون والنخيل',
        ownerName: 'عمر البشير المريمي',
        ownerNationalId: '119850239481',
        ownerPhone: '+218 91 234 5678',
        municipality: 'ترهونة',
        locationName: 'وادي المجينين / سيدي السائح',
        latitude: 32.4350,
        longitude: 13.6330,
        boundaryPoints: const [
          GeoPoint(32.4350, 13.6330, 'الزاوية الشمالية الغربية'),
          GeoPoint(32.4375, 13.6380, 'الحد الشرقي مع الطريق'),
          GeoPoint(32.4330, 13.6405, 'الزاوية الجنوبية'),
          GeoPoint(32.4310, 13.6345, 'المجرى المائي الطبيعي'),
        ],
        estimatedAreaHectares: 12.5,
        estimatedAreaDunams: 50.0,
        crops: [
          CropItem(
            id: 'CRP-1',
            cropType: 'أشجار الزيتون (شملالي وقروي)',
            season: 'شتوي / دائم',
            cultivatedAreaHectares: 8.0,
            notes: 'أشجار مثمرة بعمر 15 سنة، ري تكميلي من البئر',
          ),
          CropItem(
            id: 'CRP-2',
            cropType: 'نخيل التمور (صعيدي وبستيان)',
            season: 'صيفي / دائم',
            cultivatedAreaHectares: 3.5,
            notes: 'فسائل منتجة بجودة عالية',
          ),
        ],
        attachments: [
          AttachmentItem(
            id: 'ATT-1',
            fileName: 'شهادة_عقارية_رسمية.pdf',
            caption: 'شهادة الحيازة العقارية المصدقة',
            isDocument: true,
          ),
          AttachmentItem(
            id: 'ATT-2',
            fileName: 'صورة_بستان_الزيتون.jpg',
            caption: 'صورة حقلية لمسقط الأشجار وبئر الري',
          ),
        ],
        status: LandReviewStatus.approved,
        reviewTimeline: const [
          ReviewTimelineStep(
            title: 'تم تقديم السجل',
            date: '10 يناير 2027',
            description: 'تسجيل الحيازة عبر تطبيق فلاح وإحالة المخطط',
            isDone: true,
          ),
          ReviewTimelineStep(
            title: 'المطابقة المكانية في جُذور',
            date: '14 يناير 2027',
            description:
                'مطابقة الإحداثيات مع صور الأقمار الصناعية وخريطة المخططات',
            isDone: true,
          ),
          ReviewTimelineStep(
            title: 'المصادقة والاعتماد النهائي',
            date: '18 يناير 2027',
            description: 'تم إصدار سند الحصر الزراعي المعتمد رقم TRH-8820',
            isDone: true,
          ),
        ],
        isDraft: false,
        isSynced: true,
        createdAt: DateTime(2027, 1, 10),
        updatedAt: DateTime(2027, 1, 18),
      ),

      LandRecord(
        id: 'LND-2027-002',
        recordNumber: 'LY-SWN-2027-088',
        landName: 'حقل السواني للبطاطا والخضار الحقلية',
        ownerName: 'عمر البشير المريمي',
        ownerNationalId: '119850239481',
        ownerPhone: '+218 91 234 5678',
        municipality: 'السواني بن آدم',
        locationName: 'طريق الكريمية - السواني',
        latitude: 32.7210,
        longitude: 13.0850,
        boundaryPoints: const [
          GeoPoint(32.7210, 13.0850, 'نقطة 1'),
          GeoPoint(32.7235, 13.0910, 'نقطة 2'),
          GeoPoint(32.7180, 13.0925, 'نقطة 3'),
          GeoPoint(32.7165, 13.0860, 'نقطة 4'),
        ],
        estimatedAreaHectares: 6.2,
        estimatedAreaDunams: 24.8,
        crops: [
          CropItem(
            id: 'CRP-3',
            cropType: 'بطاطا خريفية',
            season: 'عروة خريفية 2026 / 2027',
            cultivatedAreaHectares: 4.0,
            notes: 'ري بالرشاشات المحورية',
          ),
        ],
        attachments: [
          AttachmentItem(
            id: 'ATT-3',
            fileName: 'مخطط_كروكي_مساحي.pdf',
            caption: 'رسم هندسي كروكي للحدود',
            isDocument: true,
          ),
        ],
        status: LandReviewStatus.underReview,
        reviewTimeline: const [
          ReviewTimelineStep(
            title: 'تم تقديم السجل',
            date: '28 يناير 2027',
            description: 'تم إرسال الملف إلى منصة جُذور',
            isDone: true,
          ),
          ReviewTimelineStep(
            title: 'التدقيق الفني في جُذور',
            date: 'قيد الإجراء حالياً',
            description:
                'فحص الارتدادات عن الطريق الزراعي والتثبت من خلو التداخلات',
            isDone: false,
            isCurrent: true,
          ),
          ReviewTimelineStep(
            title: 'قرار الاعتماد',
            date: 'بانتظار الاكتمال',
            description: 'المصادقة من قبل اللجنة الزراعية المختصة',
            isDone: false,
          ),
        ],
        isDraft: false,
        isSynced: true,
        createdAt: DateTime(2027, 1, 28),
        updatedAt: DateTime(2027, 1, 29),
      ),

      LandRecord(
        id: 'LND-2027-003',
        recordNumber: 'LY-TWR-2027-105',
        landName: 'أرض مشروع تاورغاء الزراعي',
        ownerName: 'عمر البشير المريمي',
        ownerNationalId: '119850239481',
        ownerPhone: '+218 91 234 5678',
        municipality: 'مصراتة',
        locationName: 'سهل تاورغاء الزراعي',
        latitude: 32.0120,
        longitude: 15.1450,
        boundaryPoints: const [
          GeoPoint(32.0120, 15.1450, 'نقطة 1'),
          GeoPoint(32.0160, 15.1500, 'نقطة 2'),
          GeoPoint(32.0110, 15.1540, 'نقطة 3 (تداخل مع حرم الطريق)'),
          GeoPoint(32.0080, 15.1470, 'نقطة 4'),
        ],
        estimatedAreaHectares: 18.0,
        estimatedAreaDunams: 72.0,
        crops: [
          CropItem(
            id: 'CRP-4',
            cropType: 'قمح صلب وشعير',
            season: 'شتوي 2026 / 2027',
            cultivatedAreaHectares: 15.0,
          ),
        ],
        attachments: [
          AttachmentItem(
            id: 'ATT-4',
            fileName: 'عقد_انتفاع_زراعي.pdf',
            caption: 'عقد الانتفاع بالحيازة',
            isDocument: true,
          ),
        ],
        status: LandReviewStatus.requiresModification,
        returnReason: 'تداخل في إحداثيات الحد الجنوبي الشرقي (النقطة رقم 3) مع حرم الطريق العام وقناة الصرف الرئيسية. يرجى تعديل موقع النقطة لتفادي التداخل.',
        affectedFields: ['الحدود والموقع على الخريطة', 'المساحة التقديرية'],
        reviewTimeline: const [
          ReviewTimelineStep(
            title: 'تم تقديم السجل',
            date: '15 يناير 2027',
            description: 'إرسال الملف لمراجعي منصة جُذور',
            isDone: true,
          ),
          ReviewTimelineStep(
            title: 'ملاحظات المراجع (يتطلب تعديلًا)',
            date: '22 يناير 2027',
            description:
                'أعاد مراجع منصة جُذور السجل مع طلب تصحيح الحد الجنوبي',
            isDone: true,
            isError: true,
          ),
          ReviewTimelineStep(
            title: 'بانتظار إعادة الإرسال من المستخدم',
            date: 'معلق',
            description: 'يرجى تصحيح النقاط وإعادة الإرسال',
            isCurrent: true,
          ),
        ],
        isDraft: false,
        isSynced: true,
        createdAt: DateTime(2027, 1, 15),
        updatedAt: DateTime(2027, 1, 22),
      ),

      LandRecord(
        id: 'LND-2027-004',
        recordNumber: 'LY-DRF-2027-002',
        landName: 'بستان الحبوب - العزيزية (مسودة محلية)',
        ownerName: 'عمر البشير المريمي',
        ownerNationalId: '119850239481',
        ownerPhone: '+218 91 234 5678',
        municipality: 'العزيزية',
        locationName: 'سهل الجفارة / جنوب العزيزية',
        latitude: 32.5333,
        longitude: 13.0167,
        boundaryPoints: const [
          GeoPoint(32.5333, 13.0167, 'نقطة البداية'),
          GeoPoint(32.5360, 13.0200, 'الحد الشرقي'),
        ],
        estimatedAreaHectares: 5.0,
        estimatedAreaDunams: 20.0,
        crops: [],
        attachments: [],
        status: LandReviewStatus.draft,
        reviewTimeline: const [
          ReviewTimelineStep(
            title: 'مسودة قيد الاستكمال',
            date: 'محفوظة محلياً',
            description: 'لم تكتمل أركان مضلع الحدود وإرفاق المستندات',
            isCurrent: true,
          ),
        ],
        isDraft: true,
        isSynced: false,
        createdAt: DateTime(2027, 2, 2),
        updatedAt: DateTime(2027, 2, 2),
      ),
    ];

    _selectedRecord = _lands.first;

    resetDraft();

    // Farmers directory for Field Surveyor role
    _farmersDirectory = const [
      FarmerDirectoryItem(
        id: 'FRM-101',
        fullName: 'الحاج مصطفى سالم الفرجاني',
        nationalId: '119640032918',
        phone: '+218 91 345 6789',
        municipality: 'ترهونة',
        registeredLandsCount: 2,
        isAuthorizedForSurveyor: true,
      ),
      FarmerDirectoryItem(
        id: 'FRM-102',
        fullName: 'عبد السلام أحمد الزنتاني',
        nationalId: '119720182736',
        phone: '+218 92 456 7890',
        municipality: 'السواني بن آدم',
        registeredLandsCount: 1,
        isAuthorizedForSurveyor: true,
      ),
      FarmerDirectoryItem(
        id: 'FRM-103',
        fullName: 'فتحي عمران الترهوني',
        nationalId: '119800293847',
        phone: '+218 91 567 8901',
        municipality: 'قصر بن غشير',
        registeredLandsCount: 3,
        isAuthorizedForSurveyor: false,
      ),
      FarmerDirectoryItem(
        id: 'FRM-104',
        fullName: 'مفتاح المهدي بن عاشور',
        nationalId: '119690182938',
        phone: '+218 93 678 9012',
        municipality: 'العزيزية',
        registeredLandsCount: 1,
        isAuthorizedForSurveyor: true,
      ),
    ];

    // Fictional Samples Catalog for Seeds & Fertilizers
    _supplies = [
      SupplyCatalogProduct(
        id: 'SUP-SD-01',
        name: 'بذور قمح صلب منتخب (صنف كريم 2027)',
        type: SupplyType.seeds,
        categoryName: 'بذور محاصيل استراتيجية',
        description: 'صنف قمح صلب عالي المقاومة للجفاف وملائم للأراضي المروية والبعلية في سهل الجفارة والمرج. عينة توضيحية للمعاينة فقط.',
        suitableCrops: 'القمح الصلب',
        seasonRecommendation: 'البذر من منتصف نوفمبر إلى نهاية ديسمبر',
        isSampleDemoData: true,
      ),
      SupplyCatalogProduct(
        id: 'SUP-SD-02',
        name: 'بذور شعير محلي محسن (سلالة وادي المجينين)',
        type: SupplyType.seeds,
        categoryName: 'بذور أعلاف وحبوب',
        description: 'بذور شعير ثنائي الصفوف تتحمل الملوحة المتوسطة للآبار الجوفية ومثالية للتربة الرملية الطمية. بيانات تجريبية استرشادية.',
        suitableCrops: 'الشعير والأعلاف',
        seasonRecommendation: 'البذر الشتوي المبكر',
        isSampleDemoData: true,
      ),
      SupplyCatalogProduct(
        id: 'SUP-SD-03',
        name: 'شتلات زيتون شملالي مؤصلة',
        type: SupplyType.seeds,
        categoryName: 'شتلات أشجار مثمرة',
        description: 'شتلات بعمر سنة واحدة مجهزة بأكياس بولي إيثيلين خالية من الآفات ومقاومة لتقلبات درجات الحرارة. بيانات تجريبية.',
        suitableCrops: 'أشجار الزيتون',
        seasonRecommendation: 'الغرس في فبراير ومارس',
        isSampleDemoData: true,
      ),
      SupplyCatalogProduct(
        id: 'SUP-FR-01',
        name: 'سماد يوريا حبيبي 46% N (نموذج محلي)',
        type: SupplyType.fertilizers,
        categoryName: 'أسمدة نيتروجينية',
        description: 'سماد سريع الذوبان يعزز النمو الخضري للمحاصيل الحقلية وأشجار الفاكهة في مرحلة النشاط. مخصص كعينة توضيحية للمنظومة.',
        suitableCrops: 'الحبوب والخضراوات والزيتون',
        seasonRecommendation: 'توزيع الدفعات أثناء مرحلة التفريع والنمو النشط',
        isSampleDemoData: true,
      ),
      SupplyCatalogProduct(
        id: 'SUP-FR-02',
        name: 'سماد داب فوسفاتي مركب 18-46-0 DAP',
        type: SupplyType.fertilizers,
        categoryName: 'أسمدة تأسيس وتجذير',
        description: 'سماد أساسي يضاف قبل الزراعة لتشجيع انتشار المجموع الجذري وتحسين امتصاص الفوسفور في الأراضي الكلسية. بيانات تجريبية.',
        suitableCrops: 'القمح، البطاطا، النخيل',
        seasonRecommendation: 'يضاف مع الحراثة الشتوية الأخيرة',
        isSampleDemoData: true,
      ),
      SupplyCatalogProduct(
        id: 'SUP-FR-03',
        name: 'سلفات بوتاسيوم ذائبة 50% K2O',
        type: SupplyType.fertilizers,
        categoryName: 'أسمدة تحجيم وجودة',
        description: 'تساعد في تحسين حجم الثمار ورفع نسبة الزيت في الزيتون وزيادة نسبة السكريات في التمور ومقاومة العطش. بيانات تجريبية.',
        suitableCrops: 'الزيتون، النخيل، الحمضيات، البطاطا',
        seasonRecommendation: 'مرحلة عقد وتكوين الثمار',
        isSampleDemoData: true,
      ),
    ];

    // Notifications Grouped
    _notifications = [
      AppNotificationItem(
        id: 'NOT-1',
        title: 'تحديث في مراجعة أرض مشروع تاورغاء',
        body: 'أعاد مراجع منصة جُذور السجل مع ملاحظة: "تداخل في إحداثيات الحد الجنوبي مع حرم الطريق". يرجى التعديل.',
        dateCategory: 'اليوم',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        relatedRecordId: 'LND-2027-003',
        statusType: LandReviewStatus.requiresModification,
        isRead: false,
      ),
      AppNotificationItem(
        id: 'NOT-2',
        title: 'اعتماد رسمي لمزرعة وادي المجينين',
        body: 'تمت المصادقة على مخطط الحيازة رقم (LY-TRH-2027-014) وأصبح السجل معتمداً في النظام.',
        dateCategory: 'أمس',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        relatedRecordId: 'LND-2027-001',
        statusType: LandReviewStatus.approved,
        isRead: true,
      ),
      AppNotificationItem(
        id: 'NOT-3',
        title: 'بدء مراجعة حقل السواني',
        body: 'الملف قيد التدقيق الهندسي المكاني من قبل الفريق الفني في منصة جُذور.',
        dateCategory: 'الأسبوع الماضي',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        relatedRecordId: 'LND-2027-002',
        statusType: LandReviewStatus.underReview,
        isRead: true,
      ),
    ];
  }
}
