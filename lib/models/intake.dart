// ============================================================================
// FILE: lib/models/intake.dart
// 
// PURPOSE: Data model for liquid intake tracking
// ============================================================================

class Intake {
  final String id;
  final DateTime timestamp;
  final String type;
  final int volume;
  final int sodium;
  final int potassium;
  final int magnesium;

  Intake({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.volume,
    this.sodium = 0,
    this.potassium = 0,
    this.magnesium = 0,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'volume': volume,
    'sodium': sodium,
    'potassium': potassium,
    'magnesium': magnesium,
  };

  // Create from JSON
  factory Intake.fromJson(Map<String, dynamic> json) => Intake(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    type: json['type'] as String,
    volume: json['volume'] as int,
    sodium: json['sodium'] as int? ?? 0,
    potassium: json['potassium'] as int? ?? 0,
    magnesium: json['magnesium'] as int? ?? 0,
  );

  // Create from legacy pipe-separated string format
  factory Intake.fromLegacyString(String data) {
    final parts = data.split('|');
    return Intake(
      id: parts[0],
      timestamp: DateTime.parse(parts[1]),
      type: parts[2],
      volume: int.parse(parts[3]),
      sodium: int.parse(parts[4]),
      potassium: int.parse(parts[5]),
      magnesium: int.parse(parts[6]),
    );
  }

  // Convert to legacy pipe-separated string format
  String toLegacyString() {
    return '$id|${timestamp.toIso8601String()}|$type|$volume|$sodium|$potassium|$magnesium';
  }

  // Copy with modifications
  Intake copyWith({
    String? id,
    DateTime? timestamp,
    String? type,
    int? volume,
    int? sodium,
    int? potassium,
    int? magnesium,
  }) {
    return Intake(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      volume: volume ?? this.volume,
      sodium: sodium ?? this.sodium,
      potassium: potassium ?? this.potassium,
      magnesium: magnesium ?? this.magnesium,
    );
  }

  // Get formatted time string
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}';
  }

  // Check if intake contains water
  bool get isWaterIntake {
    return type == 'water' || type == 'electrolyte' || type == 'broth';
  }

  // Check if intake is caffeinated
  bool get isCaffeinated {
    return type == 'coffee' || type == 'tea';
  }

  // Get total electrolytes
  int get totalElectrolytes => sodium + potassium + magnesium;

  @override
  String toString() {
    return 'Intake(id: $id, timestamp: $timestamp, type: $type, '
           'volume: $volume, sodium: $sodium, potassium: $potassium, magnesium: $magnesium)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Intake &&
      other.id == id &&
      other.timestamp == timestamp &&
      other.type == type &&
      other.volume == volume &&
      other.sodium == sodium &&
      other.potassium == potassium &&
      other.magnesium == magnesium;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      timestamp.hashCode ^
      type.hashCode ^
      volume.hashCode ^
      sodium.hashCode ^
      potassium.hashCode ^
      magnesium.hashCode;
  }
}