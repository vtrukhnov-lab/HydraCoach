/// Категории напитков для премиум функции
/// 8 основных категорий для удобной навигации

enum DrinkCategory {
  water('water', '💧'),           // Вода и базовые напитки
  hotDrinks('hot_drinks', '☕'),   // Горячие напитки
  juice('juice', '🥤'),            // Соки и смузи
  sports('sports', '⚡'),          // Спортивные напитки
  dairy('dairy', '🥛'),            // Молочные продукты
  alcohol('alcohol', '🍺'),        // Алкогольные напитки
  supplements('supplements', '💊'), // Добавки и БАДы
  other('other', '🥤');            // Прочее

  final String key;
  final String emoji;
  
  const DrinkCategory(this.key, this.emoji);
  
  /// Получить локализованное название категории
  /// В arb файлах должны быть ключи: category_water, category_hot_drinks и т.д.
  String getLocalizedName(dynamic l10n) {
    final locKey = 'category_$key';
    try {
      return l10n.toJson()[locKey] ?? key.replaceAll('_', ' ');
    } catch (e) {
      return key.replaceAll('_', ' ');
    }
  }
}

/// Подкатегории для алкоголя (для детализации)
enum AlcoholSubCategory {
  beer('beer'),
  wine('wine'),
  spirits('spirits'),
  cocktails('cocktails'),
  lowAlcohol('low_alcohol');
  
  final String key;
  const AlcoholSubCategory(this.key);
}

/// Информация о категории
class CategoryInfo {
  final DrinkCategory category;
  final String iconPath;
  final int sortOrder;
  final bool isPremium;
  final bool requiresWarning; // Для алкоголя
  
  const CategoryInfo({
    required this.category,
    required this.iconPath,
    required this.sortOrder,
    this.isPremium = false,
    this.requiresWarning = false,
  });
}

/// Метаданные категорий
const Map<DrinkCategory, CategoryInfo> categoryMetadata = {
  DrinkCategory.water: CategoryInfo(
    category: DrinkCategory.water,
    iconPath: 'assets/icons/water.svg',
    sortOrder: 1,
    isPremium: false,
  ),
  DrinkCategory.hotDrinks: CategoryInfo(
    category: DrinkCategory.hotDrinks,
    iconPath: 'assets/icons/hot_drinks.svg',
    sortOrder: 2,
    isPremium: false,
  ),
  DrinkCategory.juice: CategoryInfo(
    category: DrinkCategory.juice,
    iconPath: 'assets/icons/juice.svg',
    sortOrder: 3,
    isPremium: true,
  ),
  DrinkCategory.sports: CategoryInfo(
    category: DrinkCategory.sports,
    iconPath: 'assets/icons/sports.svg',
    sortOrder: 4,
    isPremium: true,
  ),
  DrinkCategory.dairy: CategoryInfo(
    category: DrinkCategory.dairy,
    iconPath: 'assets/icons/dairy.svg',
    sortOrder: 5,
    isPremium: true,
  ),
  DrinkCategory.alcohol: CategoryInfo(
    category: DrinkCategory.alcohol,
    iconPath: 'assets/icons/alcohol.svg',
    sortOrder: 6,
    isPremium: true,
    requiresWarning: true,
  ),
  DrinkCategory.supplements: CategoryInfo(
    category: DrinkCategory.supplements,
    iconPath: 'assets/icons/supplements.svg',
    sortOrder: 7,
    isPremium: true,
  ),
  DrinkCategory.other: CategoryInfo(
    category: DrinkCategory.other,
    iconPath: 'assets/icons/other.svg',
    sortOrder: 8,
    isPremium: true,
  ),
};