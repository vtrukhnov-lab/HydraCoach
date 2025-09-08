// ============================================================================
// FILE: lib/models/daily_goals.dart
// 
// PURPOSE: Data model for daily hydration and electrolyte goals
// ============================================================================

class DailyGoals {
  final int waterMin;
  final int waterOpt;
  final int waterMax;
  final int sodium;
  final int potassium;
  final int magnesium;

  DailyGoals({
    required this.waterMin,
    required this.waterOpt,
    required this.waterMax,
    required this.sodium,
    required this.potassium,
    required this.magnesium,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'waterMin': waterMin,
    'waterOpt': waterOpt,
    'waterMax': waterMax,
    'sodium': sodium,
    'potassium': potassium,
    'magnesium': magnesium,
  };

  // Create from JSON
  factory DailyGoals.fromJson(Map<String, dynamic> json) => DailyGoals(
    waterMin: json['waterMin'] as int,
    waterOpt: json['waterOpt'] as int,
    waterMax: json['waterMax'] as int,
    sodium: json['sodium'] as int,
    potassium: json['potassium'] as int,
    magnesium: json['magnesium'] as int,
  );

  // Copy with modifications
  DailyGoals copyWith({
    int? waterMin,
    int? waterOpt,
    int? waterMax,
    int? sodium,
    int? potassium,
    int? magnesium,
  }) {
    return DailyGoals(
      waterMin: waterMin ?? this.waterMin,
      waterOpt: waterOpt ?? this.waterOpt,
      waterMax: waterMax ?? this.waterMax,
      sodium: sodium ?? this.sodium,
      potassium: potassium ?? this.potassium,
      magnesium: magnesium ?? this.magnesium,
    );
  }

  @override
  String toString() {
    return 'DailyGoals(waterMin: $waterMin, waterOpt: $waterOpt, waterMax: $waterMax, '
           'sodium: $sodium, potassium: $potassium, magnesium: $magnesium)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is DailyGoals &&
      other.waterMin == waterMin &&
      other.waterOpt == waterOpt &&
      other.waterMax == waterMax &&
      other.sodium == sodium &&
      other.potassium == potassium &&
      other.magnesium == magnesium;
  }

  @override
  int get hashCode {
    return waterMin.hashCode ^
      waterOpt.hashCode ^
      waterMax.hashCode ^
      sodium.hashCode ^
      potassium.hashCode ^
      magnesium.hashCode;
  }
}