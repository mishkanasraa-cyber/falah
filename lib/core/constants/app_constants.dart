import '../../models/land_model.dart';
import '../../models/crop_and_supply_model.dart';

class AppConstants {
  static const String appNameAr = 'فلاح';
  static const String appTaglineAr = 'المنظومة الرقمية للتوثيق العقاري والتمكين الزراعي الذكي';

  // Libyan Agricultural Regions
  static const List<String> libyanRegions = [
    'الجفارة (العزيزية، السواني، الزهراء)',
    'طرابلس وضواحيها (عين زارة، قصر بن غشير، تاجوراء)',
    'وادي المجينين وترهونة',
    'مصراتة وزريق وتاورغاء',
    'زليتن والجمعة',
    'الجبل الأخضر (شحات، البيضاء، المرج)',
    'سهل بنغازي وسلوق',
    'بني وليد ومردوم',
    'فزان ووادي الآجال وسوكنة (النخيل)',
    'الزاوية وصرمان وغريان',
  ];

  static const List<String> soilTypes = [
    'تربة حمراء طينية (مناسبة للزيتون والحبوب)',
    'تربة رملية طمية نفاذة (مناسبة للنخيل والبطاطا)',
    'تربة غرينية فيضية خصبة (مناسبة للخضار والحمضيات)',
    'تربة كلسية جيرية (شائعة في المرتفعات)',
    'تربة طينية ثقيلة متماسكة',
  ];

  static const List<String> waterSources = [
    'بئر جوفي ارتوازي خاص (مضخة غاطسة)',
    'شبكة مياه منظومة النهر الصناعي',
    'مياه سطحية / سدود (سد وادي المجينين/وادي زارت)',
    'ري معتمد على مياه الأمطار الشتوية (بعلي)',
    'محطة تحلية مياه زراعية مشتركة',
  ];

  static const List<String> cropCategories = [
    'أشجار الزيتون (شملالي، قروي، نيبالي)',
    'نخيل التمور (صعيدي، دجلة، برني، حليمة)',
    'الحبوب الاستراتيجية (قمح صلب، شعير)',
    'الخضراوات الحقلية (طماطم، بطاطا، بصل)',
    'الحمضيات (برتقال، كلمنتينا، ليمون)',
    'أعلاف خضراء (برسيم حجازي، ذرة علفية)',
  ];

  // Seed data for Libyan lands
  static List<LandRecord> getInitialLands() {
    return [
      LandRecord(
        id: 'LND-2026-0081',
        parcelNumber: 'قطعة رقم 144 / حوض 12 - الجفارة',
        title: 'مزرعة وادي المجينين للزيتون والنخيل',
        ownerName: 'الحاج عبد السلام المريمي',
        nationalId: '119640032918',
        region: 'وادي المجينين وترهونة',
        municipality: 'سيدي السائح / ترهونة',
        areaHectares: 14.5,
        areaDunams: 58.0,
        crops: ['أشجار الزيتون (شملالي)', 'نخيل التمور (صعيدي)', 'قمح صلب'],
        soilType: 'تربة حمراء طينية (مناسبة للزيتون والحبوب)',
        waterSource: 'بئر جوفي ارتوازي خاص (مضخة غاطسة)',
        boundaryPoints: const [
          GeoPoint(32.5512, 13.2840, 'نقطة البداية الشمالية'),
          GeoPoint(32.5540, 13.2895, 'الحد الشرقي مع الطريق الزراعي'),
          GeoPoint(32.5485, 13.2920, 'الزاوية الجنوبية المحاذية للمجرى'),
          GeoPoint(32.5460, 13.2855, 'الحد الغربي المحاذي لمزرعة الكيلاني'),
        ],
        status: LandReviewStatus.approved,
        photos: [
          'olive_grove_wadi.jpg',
          'water_well_pump.jpg',
        ],
        documents: [
          'شهادة_عقارية_رقم_9821.pdf',
          'مخطط_مساحي_معتمد_2026.pdf',
        ],
        reviewNotes: 'تمت مطابقة الإحداثيات المساحية مع السجل العقاري لفرع الجفارة واعتماد المساحة نظامياً.',
        createdAt: DateTime(2026, 9, 15),
      ),
      LandRecord(
        id: 'LND-2026-0142',
        parcelNumber: 'قطعة 87 - مخطط السواني الزراعي',
        title: 'حقل السواني للخضراوات والبطاطا',
        ownerName: 'عمر مصطفى الزنتاني',
        nationalId: '119850239481',
        region: 'الجفارة (العزيزية، السواني، الزهراء)',
        municipality: 'السواني بن آدم',
        areaHectares: 8.2,
        areaDunams: 32.8,
        crops: ['بطاطا صيفية', 'طماطم حقلية بيوت محمية'],
        soilType: 'تربة رملية طمية نفاذة (مناسبة للنخيل والبطاطا)',
        waterSource: 'شبكة مياه منظومة النهر الصناعي',
        boundaryPoints: const [
          GeoPoint(32.7210, 13.0850, 'شمال غرب'),
          GeoPoint(32.7235, 13.0910, 'شمال شرق'),
          GeoPoint(32.7180, 13.0925, 'جنوب شرق'),
          GeoPoint(32.7165, 13.0860, 'جنوب غرب'),
        ],
        status: LandReviewStatus.underReview,
        photos: [
          'greenhouse_swani.jpg',
        ],
        documents: [
          'إفادة_حيازة_زراعية.pdf',
          'رسم_كروكي_مساحي.pdf',
        ],
        reviewNotes: 'الملف قيد المراجعة الفنية من قبل المهندس المفتش لتأكيد حدود الارتداد عن الطريق الرئيسي.',
        createdAt: DateTime(2026, 10, 28),
      ),
      LandRecord(
        id: 'LND-2026-0209',
        parcelNumber: 'قطعة 12 / كرمة زليتن الشرقية',
        title: 'بستان زليتن للحمضيات والنخيل',
        ownerName: 'مفتاح سالم الفيتوري',
        nationalId: '119780193847',
        region: 'زليتن والجمعة',
        municipality: 'زليتن المركز',
        areaHectares: 5.0,
        areaDunams: 20.0,
        crops: ['حمضيات (برتقال، ليمون)', 'نخيل دجلة'],
        soilType: 'تربة غرينية فيضية خصبة (مناسبة للخضار والحمضيات)',
        waterSource: 'بئر جوفي ارتوازي خاص (مضخة غاطسة)',
        boundaryPoints: const [
          GeoPoint(32.4650, 14.5710, 'نقطة 1'),
          GeoPoint(32.4675, 14.5755, 'نقطة 2'),
          GeoPoint(32.4630, 14.5770, 'نقطة 3'),
          GeoPoint(32.4610, 14.5720, 'نقطة 4'),
        ],
        status: LandReviewStatus.draft,
        photos: [],
        documents: [],
        reviewNotes: 'مسودة لم تكتمل - يرجى إرفاق المستند العقاري ورسم الكروكي لإرسالها للتدقيق.',
        createdAt: DateTime(2026, 11, 5),
      ),
    ];
  }

  // Libyan Agricultural Supplies & Seeds
  static List<AgriculturalSupply> getInitialSupplies() {
    return [
      AgriculturalSupply(
        id: 'SUP-001',
        name: 'سماد يوريا نقي 46% (المجمع الصناعي)',
        category: SupplyCategory.fertilizers,
        description: 'سماد نيتروجيني عالي الفاعلية لتنشيط النمو الخضري للحبوب والخضار في التربة الليبية.',
        targetCrops: 'القمح، الشعير، الطماطم، البطاطا، الأعلاف',
        dosageGuideline: '120-150 كجم/هكتار تضاف على دفعتين مع بداية التفرع والنمو النشط',
        libyanDistributor: 'الشركة الليبية للأسمدة والمبيدات الزراعية',
        subsidyPercentage: 40.0,
        isAvailableInCooperative: true,
      ),
      AgriculturalSupply(
        id: 'SUP-002',
        name: 'سماد داب مركب NPK 18-46-0 عالي الفوسفور',
        category: SupplyCategory.fertilizers,
        description: 'سماد أساسي لتجذير الشتلات وتأسيس زراعات القمح والبطاطا وتحسين بنية التربة الطينية.',
        targetCrops: 'الحبوب، أشجار الزيتون الفتية، الخضراوات',
        dosageGuideline: '100 كجم/هكتار تضاف قبل الحراثة الأخيرة والزراعة',
        libyanDistributor: 'الجمعيات التعاونية الزراعية - وزارة الزراعة',
        subsidyPercentage: 35.0,
        isAvailableInCooperative: true,
      ),
      AgriculturalSupply(
        id: 'SUP-003',
        name: 'بذور قمح صلب معتمدة (صنف كريم وشحات)',
        category: SupplyCategory.seeds,
        description: 'بذور منتخبة مقاومة للجفاف وملائمة للبيئة المناخية الليبية بمعدل إنبات يتجاوز 95%.',
        targetCrops: 'القمح والزراعات الاستراتيجية',
        dosageGuideline: '110-125 كجم/هكتار في الزراعة المطرية والمروية',
        libyanDistributor: 'مركز البحوث الزراعية والحيوانية - طرابلس/المرج',
        subsidyPercentage: 50.0,
        isAvailableInCooperative: true,
      ),
      AgriculturalSupply(
        id: 'SUP-004',
        name: 'مبيد فطري نحاسي (هيدروكسيد النحاس 77%)',
        category: SupplyCategory.pesticides,
        description: 'علاج وقائي وعلاجي أساسي لمكافحة مرض عين الطاووس في الزيتون واللفحة في الطماطم.',
        targetCrops: 'أشجار الزيتون، الطماطم، البطاطا، الحمضيات',
        dosageGuideline: '250-300 جم لكل 100 لتر ماء رشا بعد تقليم الزيتون أو هطول الأمطار',
        libyanDistributor: 'المستودع الزراعي الوطني',
        subsidyPercentage: 20.0,
        isAvailableInCooperative: true,
      ),
    ];
  }

  // Libyan Crop Seasons
  static List<LibyanCropSeason> getCropSeasons() {
    return [
      LibyanCropSeason(
        id: 'CS-01',
        name: 'Olive Season',
        arabicName: 'موسم الزيتون الليبي',
        seasonPeriod: 'الخريف إلى الشتاء (أكتوبر - يناير)',
        bestSowingMonths: 'فبراير - أبريل (للشتلات)',
        harvestMonths: 'نوفمبر - يناير (موسم الجني والعصر)',
        irrigationNeeds: 'ري تكميلي خلال أشهر الصيف الجافة (يونيو - أغسطس) بفاصل 15 يوماً',
        soilPreference: 'تربة حمراء طينية جيدة الصرف أو رملية طمية عميقة',
        primaryRegions: ['ترهونة وغريان', 'الجفارة ومسلاتة', 'سرت ومصراتة', 'الجبل الأخضر'],
        tips: 'ينصح بالرش الوقائي بمركبات النحاس فور انتهاء موسم الجني لحماية الشجرة من فطر عين الطاووس وتبكير التقليم لتشبيب الأغصان.',
      ),
      LibyanCropSeason(
        id: 'CS-02',
        name: 'Wheat & Barley',
        arabicName: 'موسم القمح الصلب والشعير',
        seasonPeriod: 'الشتاء إلى الربيع (نوفمبر - مايو)',
        bestSowingMonths: '15 نوفمبر إلى 20 ديسمبر (بعد المطر الأول)',
        harvestMonths: 'مايو - يونيو',
        irrigationNeeds: 'ري محوري منتظم عند انحباس الأمطار، مع التركيز على مرحلة طرد السنابل',
        soilPreference: 'تربة طينية خصبة عميقة في سهول الجفارة والمرج',
        primaryRegions: ['سهل الجفارة', 'سهل بنغازي والمرج', 'وادي سوف الجين', 'مشروع مكنوسة فزان'],
        tips: 'استخدم بذوراً معتمدة من مركز البحوث (أصناف شحات وكريم)، ولا تهمل إضافة سماد الداب أثناء البذر.',
      ),
      LibyanCropSeason(
        id: 'CS-03',
        name: 'Date Palm',
        arabicName: 'موسم نخيل التمور',
        seasonPeriod: 'الربيع للصيف حتى الجني (مارس - أكتوبر)',
        bestSowingMonths: 'مارس - مايو (لغرس الفسائل)',
        harvestMonths: 'سبتمبر - نوفمبر (موسم الخراف)',
        irrigationNeeds: 'ري غزير ومنتظم خلال التزهير وعقد الثمار (أبريل - يوليو) وتقليل الري قبل الجني بأسبوعين',
        soilPreference: 'تتحمل الملوحة الخفيفة، وتجود في الأراضي الرملية الطمية النفاذة',
        primaryRegions: ['واحات فزان (سبها، أوباري)', 'واحة الجفرة (هون، ودان)', 'واحات جالو وأوجلة', 'زليتن وطرابلس'],
        tips: 'الفحص الدوري لقواعد الجريد لمكافحة سوسة النخيل الحمراء، وتكريب النخيل في الموعد المحدد مع خف العراجين لضمان حجم ثمار ممتاز.',
      ),
      LibyanCropSeason(
        id: 'CS-04',
        name: 'Potatoes & Tomatoes',
        arabicName: 'البطاطا والطماطم الحقلية',
        seasonPeriod: 'العروة الخريفية والربيعية',
        bestSowingMonths: 'العروة الأولى: سبتمبر - أكتوبر | العروة الثانية: فبراير - مارس',
        harvestMonths: 'يناير - فبراير (للخريفية) | مايو - يونيو (للربيعية)',
        irrigationNeeds: 'ري بالتنقيط عالي الكفاءة للحفاظ على رطوبة متوازنة ومنع تعفن الجذور',
        soilPreference: 'تربة رملية مفككة جيدة التهوية خالية من الأحجار',
        primaryRegions: ['السواني والعزيزية', 'قصر بن غشير', 'مصراتة وزريق', 'سهل بنغازي'],
        tips: 'إضافة سماد البوتاسيوم في مرحلة درنات البطاطا يرفع وزن المحصول ومقاومته للندوات الفطرية.',
      ),
    ];
  }
}
