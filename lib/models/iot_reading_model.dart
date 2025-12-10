class IotReading {
  final int id;
  final String deviceId;
  final String userId;
  final double? soilMoisture;
  final double? waterLevel;
  final double? plantGrowth;
  final double? temperature;
  final double? humidity;
  final DateTime createdAt;

  IotReading({
    required this.id,
    required this.deviceId,
    required this.userId,
    this.soilMoisture,
    this.waterLevel,
    this.plantGrowth,
    this.temperature,
    this.humidity,
    required this.createdAt,
  });

  /// Creates an IotReading instance from a JSON map (Supabase response)
  factory IotReading.fromJson(Map<String, dynamic> json) {
    return IotReading(
      id: json['id'] as int,
      deviceId: json['device_id'] as String,
      userId: json['user_id'] as String,
      soilMoisture: _parseDouble(json['soil_moisture']),
      waterLevel: _parseDouble(json['water_level']),
      plantGrowth: _parseDouble(json['plant_growth']),
      temperature: _parseDouble(json['temperature']),
      humidity: _parseDouble(json['humidity']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Converts the IotReading instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'user_id': userId,
      'soil_moisture': soilMoisture,
      'water_level': waterLevel,
      'plant_growth': plantGrowth,
      'temperature': temperature,
      'humidity': humidity,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Helper method to safely parse numeric values from Supabase to double
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  @override
  String toString() =>
      'IotReading(device: $deviceId, temp: ${temperature}°C, humidity: ${humidity}%)';
}
