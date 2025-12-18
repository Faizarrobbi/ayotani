class Land {
  final int id;
  final String userId;
  final String name;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? plantType;
  final DateTime? plantingDate;
  final DateTime? harvestDate;
  final double areaSize;
  final String? imageUrl;
  
  // New Financial Fields
  final double modalPerKg;
  final double targetProfitPercentage;
  final double targetHarvestKg;

  Land({
    required this.id,
    required this.userId,
    required this.name,
    this.location,
    this.latitude,
    this.longitude,
    this.plantType,
    this.plantingDate,
    this.harvestDate,
    this.areaSize = 0,
    this.imageUrl,
    this.modalPerKg = 0,
    this.targetProfitPercentage = 0,
    this.targetHarvestKg = 0,
  });

  factory Land.fromJson(Map<String, dynamic> json) {
    return Land(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(), 
      longitude: (json['longitude'] as num?)?.toDouble(),
      plantType: json['plant_type'] as String?,
      plantingDate: json['planting_date'] != null ? DateTime.parse(json['planting_date']) : null,
      harvestDate: json['harvest_date'] != null ? DateTime.parse(json['harvest_date']) : null,
      areaSize: (json['area_size'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
      modalPerKg: (json['modal_per_kg'] as num?)?.toDouble() ?? 0.0,
      targetProfitPercentage: (json['target_profit_percentage'] as num?)?.toDouble() ?? 0.0,
      targetHarvestKg: (json['target_harvest_kg'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'plant_type': plantType,
      'planting_date': plantingDate?.toIso8601String(),
      'harvest_date': harvestDate?.toIso8601String(),
      'area_size': areaSize,
      'image_url': imageUrl,
      'modal_per_kg': modalPerKg,
      'target_profit_percentage': targetProfitPercentage,
      'target_harvest_kg': targetHarvestKg,
    };
  }
}