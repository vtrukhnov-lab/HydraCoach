/// База данных добавок и БАДов для премиум функции
/// Добавки можно применять к любому напитку для корректировки электролитов

enum SupplementType {
  electrolyte('electrolyte', '⚡'),
  vitamin('vitamin', '💊'),
  mineral('mineral', '💎'),
  herbal('herbal', '🌿'),
  other('other', '🧪');
  
  final String key;
  final String emoji;
  
  const SupplementType(this.key, this.emoji);
}

/// Модель добавки
class Supplement {
  final String id;
  final String nameKey; // Для локализации (например: 'supplement_salt', 'supplement_magnesium_citrate')
  final SupplementType type;
  final String emoji;
  final String? descriptionKey; // Для локализации описания
  
  // Содержание на одну порцию (обычно 1 таблетка/пакетик/мерная ложка)
  final double? sodiumMg;
  final double? potassiumMg;
  final double? magnesiumMg;
  final double? calciumMg;
  final double? chlorideMg;
  final double? zincMg;
  
  // Витамины (если есть)
  final double? vitaminCMg;
  final double? vitaminDIu;
  final double? vitaminB12Mcg;
  
  // Дополнительные свойства
  final bool isPremium;
  final bool isPopular;
  final String? warningKey; // Предупреждение если есть (локализация)
  final double defaultServingSize; // Обычно 1.0 = 1 порция
  
  const Supplement({
    required this.id,
    required this.nameKey,
    required this.type,
    required this.emoji,
    this.descriptionKey,
    this.sodiumMg,
    this.potassiumMg,
    this.magnesiumMg,
    this.calciumMg,
    this.chlorideMg,
    this.zincMg,
    this.vitaminCMg,
    this.vitaminDIu,
    this.vitaminB12Mcg,
    this.isPremium = true,
    this.isPopular = false,
    this.warningKey,
    this.defaultServingSize = 1.0,
  });
  
  /// Получить локализованное название
  String getLocalizedName(dynamic l10n) {
    try {
      return l10n.toJson()[nameKey] ?? nameKey.replaceAll('_', ' ');
    } catch (e) {
      return nameKey.replaceAll('supplement_', '').replaceAll('_', ' ');
    }
  }
  
  /// Получить локализованное описание
  String? getLocalizedDescription(dynamic l10n) {
    if (descriptionKey == null) return null;
    try {
      return l10n.toJson()[descriptionKey!];
    } catch (e) {
      return null;
    }
  }
}

/// База данных всех добавок
class SupplementDatabase {
  static const List<Supplement> allSupplements = [
    // ===== ЭЛЕКТРОЛИТНЫЕ ДОБАВКИ =====
    Supplement(
      id: 'salt_regular',
      nameKey: 'supplement_salt',
      type: SupplementType.electrolyte,
      emoji: '🧂',
      descriptionKey: 'supplement_salt_desc',
      sodiumMg: 400, // на 1г соли
      chlorideMg: 600,
      isPremium: false,
      isPopular: true,
      defaultServingSize: 1.0, // 1 грамм
    ),
    Supplement(
      id: 'salt_himalayan',
      nameKey: 'supplement_himalayan_salt',
      type: SupplementType.electrolyte,
      emoji: '🏔️',
      descriptionKey: 'supplement_himalayan_desc',
      sodiumMg: 380,
      potassiumMg: 2.8,
      magnesiumMg: 1.06,
      calciumMg: 1.6,
      chlorideMg: 590,
      isPremium: true,
      isPopular: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'salt_celtic',
      nameKey: 'supplement_celtic_salt',
      type: SupplementType.electrolyte,
      emoji: '🌊',
      descriptionKey: 'supplement_celtic_desc',
      sodiumMg: 330,
      magnesiumMg: 4.4,
      potassiumMg: 2.9,
      calciumMg: 1.5,
      isPremium: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'electrolyte_powder',
      nameKey: 'supplement_electrolyte_powder',
      type: SupplementType.electrolyte,
      emoji: '⚡',
      descriptionKey: 'supplement_electrolyte_powder_desc',
      sodiumMg: 500,
      potassiumMg: 200,
      magnesiumMg: 60,
      chlorideMg: 750,
      isPremium: true,
      isPopular: true,
      defaultServingSize: 1.0, // 1 пакетик
    ),
    Supplement(
      id: 'lmnt',
      nameKey: 'supplement_lmnt',
      type: SupplementType.electrolyte,
      emoji: '💪',
      descriptionKey: 'supplement_lmnt_desc',
      sodiumMg: 1000,
      potassiumMg: 200,
      magnesiumMg: 60,
      isPremium: true,
      isPopular: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'nuun',
      nameKey: 'supplement_nuun',
      type: SupplementType.electrolyte,
      emoji: '💧',
      descriptionKey: 'supplement_nuun_desc',
      sodiumMg: 300,
      potassiumMg: 150,
      magnesiumMg: 25,
      calciumMg: 13,
      isPremium: true,
      defaultServingSize: 1.0, // 1 таблетка
    ),
    Supplement(
      id: 'liquid_iv',
      nameKey: 'supplement_liquid_iv',
      type: SupplementType.electrolyte,
      emoji: '💦',
      descriptionKey: 'supplement_liquid_iv_desc',
      sodiumMg: 500,
      potassiumMg: 370,
      vitaminCMg: 78,
      isPremium: true,
      isPopular: true,
      defaultServingSize: 1.0,
    ),
    
    // ===== МИНЕРАЛЬНЫЕ ДОБАВКИ =====
    Supplement(
      id: 'magnesium_citrate',
      nameKey: 'supplement_magnesium_citrate',
      type: SupplementType.mineral,
      emoji: '💊',
      descriptionKey: 'supplement_magnesium_citrate_desc',
      magnesiumMg: 200,
      isPremium: true,
      isPopular: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'magnesium_glycinate',
      nameKey: 'supplement_magnesium_glycinate',
      type: SupplementType.mineral,
      emoji: '💊',
      descriptionKey: 'supplement_magnesium_glycinate_desc',
      magnesiumMg: 200,
      isPremium: true,
      warningKey: 'supplement_mag_glycinate_warning',
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'potassium_citrate',
      nameKey: 'supplement_potassium_citrate',
      type: SupplementType.mineral,
      emoji: '💊',
      descriptionKey: 'supplement_potassium_citrate_desc',
      potassiumMg: 99, // FDA ограничение
      isPremium: true,
      warningKey: 'supplement_potassium_warning',
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'calcium_citrate',
      nameKey: 'supplement_calcium_citrate',
      type: SupplementType.mineral,
      emoji: '💊',
      descriptionKey: 'supplement_calcium_citrate_desc',
      calciumMg: 200,
      isPremium: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'zinc_picolinate',
      nameKey: 'supplement_zinc',
      type: SupplementType.mineral,
      emoji: '💊',
      descriptionKey: 'supplement_zinc_desc',
      zincMg: 15,
      isPremium: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'trace_minerals',
      nameKey: 'supplement_trace_minerals',
      type: SupplementType.mineral,
      emoji: '💧',
      descriptionKey: 'supplement_trace_minerals_desc',
      magnesiumMg: 250,
      chlorideMg: 650,
      sodiumMg: 5,
      potassiumMg: 3,
      isPremium: true,
      defaultServingSize: 2.5, // 2.5 мл
    ),
    
    // ===== ВИТАМИННЫЕ ДОБАВКИ =====
    Supplement(
      id: 'vitamin_c',
      nameKey: 'supplement_vitamin_c',
      type: SupplementType.vitamin,
      emoji: '🍊',
      descriptionKey: 'supplement_vitamin_c_desc',
      vitaminCMg: 1000,
      isPremium: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'vitamin_d3',
      nameKey: 'supplement_vitamin_d3',
      type: SupplementType.vitamin,
      emoji: '☀️',
      descriptionKey: 'supplement_vitamin_d3_desc',
      vitaminDIu: 2000,
      isPremium: true,
      isPopular: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'b_complex',
      nameKey: 'supplement_b_complex',
      type: SupplementType.vitamin,
      emoji: '💊',
      descriptionKey: 'supplement_b_complex_desc',
      vitaminB12Mcg: 500,
      isPremium: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'emergen_c',
      nameKey: 'supplement_emergen_c',
      type: SupplementType.vitamin,
      emoji: '🍊',
      descriptionKey: 'supplement_emergen_c_desc',
      vitaminCMg: 1000,
      sodiumMg: 60,
      potassiumMg: 200,
      isPremium: true,
      defaultServingSize: 1.0,
    ),
    
    // ===== ТРАВЯНЫЕ ДОБАВКИ =====
    Supplement(
      id: 'ashwagandha',
      nameKey: 'supplement_ashwagandha',
      type: SupplementType.herbal,
      emoji: '🌿',
      descriptionKey: 'supplement_ashwagandha_desc',
      isPremium: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'turmeric',
      nameKey: 'supplement_turmeric',
      type: SupplementType.herbal,
      emoji: '🌾',
      descriptionKey: 'supplement_turmeric_desc',
      isPremium: true,
      defaultServingSize: 1.0,
    ),
    Supplement(
      id: 'ginger_powder',
      nameKey: 'supplement_ginger',
      type: SupplementType.herbal,
      emoji: '🫚',
      descriptionKey: 'supplement_ginger_desc',
      isPremium: true,
      defaultServingSize: 0.5, // 0.5 грамма
    ),
    
    // ===== ДРУГИЕ ДОБАВКИ =====
    Supplement(
      id: 'creatine',
      nameKey: 'supplement_creatine',
      type: SupplementType.other,
      emoji: '💪',
      descriptionKey: 'supplement_creatine_desc',
      isPremium: true,
      isPopular: true,
      defaultServingSize: 5.0, // 5 грамм
    ),
    Supplement(
      id: 'collagen',
      nameKey: 'supplement_collagen',
      type: SupplementType.other,
      emoji: '🦴',
      descriptionKey: 'supplement_collagen_desc',
      isPremium: true,
      defaultServingSize: 10.0, // 10 грамм
    ),
    Supplement(
      id: 'mct_oil',
      nameKey: 'supplement_mct_oil',
      type: SupplementType.other,
      emoji: '🥥',
      descriptionKey: 'supplement_mct_oil_desc',
      isPremium: true,
      isPopular: true,
      defaultServingSize: 15.0, // 15 мл
    ),
    Supplement(
      id: 'apple_cider_vinegar',
      nameKey: 'supplement_acv',
      type: SupplementType.other,
      emoji: '🍎',
      descriptionKey: 'supplement_acv_desc',
      potassiumMg: 11,
      isPremium: true,
      warningKey: 'supplement_acv_warning',
      defaultServingSize: 15.0, // 15 мл
    ),
    Supplement(
      id: 'lemon_juice',
      nameKey: 'supplement_lemon_juice',
      type: SupplementType.other,
      emoji: '🍋',
      descriptionKey: 'supplement_lemon_juice_desc',
      vitaminCMg: 18.6,
      potassiumMg: 49,
      isPremium: false,
      isPopular: true,
      defaultServingSize: 30.0, // 30 мл (2 столовые ложки)
    ),
    Supplement(
      id: 'baking_soda',
      nameKey: 'supplement_baking_soda',
      type: SupplementType.other,
      emoji: '🧂',
      descriptionKey: 'supplement_baking_soda_desc',
      sodiumMg: 1260, // на 3г (половина чайной ложки)
      isPremium: true,
      warningKey: 'supplement_baking_soda_warning',
      defaultServingSize: 3.0,
    ),
  ];
  
  /// Получить все добавки по типу
  static List<Supplement> getSupplementsByType(SupplementType type) {
    return allSupplements.where((s) => s.type == type).toList();
  }
  
  /// Получить популярные добавки
  static List<Supplement> getPopularSupplements() {
    return allSupplements.where((s) => s.isPopular).toList();
  }
  
  /// Получить бесплатные добавки
  static List<Supplement> getFreeSupplements() {
    return allSupplements.where((s) => !s.isPremium).toList();
  }
  
  /// Найти добавку по ID
  static Supplement? findById(String id) {
    try {
      return allSupplements.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
  
  /// Поиск добавок
  static List<Supplement> searchSupplements(String query) {
    final lowerQuery = query.toLowerCase();
    return allSupplements.where((s) => 
      s.id.toLowerCase().contains(lowerQuery) ||
      s.nameKey.toLowerCase().contains(lowerQuery)
    ).toList();
  }
  
  /// Получить добавки с электролитами
  static List<Supplement> getElectrolyteSupplements() {
    return allSupplements.where((s) => 
      s.sodiumMg != null || 
      s.potassiumMg != null || 
      s.magnesiumMg != null
    ).toList();
  }
}