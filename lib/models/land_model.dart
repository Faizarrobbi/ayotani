class Land {
  final int id;
  final String userId;
  final String name;
  final String? location;
  final String? plantType;
  final DateTime? plantingDate;
  final DateTime? harvestDate;
  final double areaSize;
  final String? imageUrl;

  Land({
    required this.id,
    required this.userId,
    required this.name,
    this.location,
    this.plantType,
    this.plantingDate,
    this.harvestDate,
    this.areaSize = 0,
    this.imageUrl,
  });

  factory Land.fromJson(Map<String, dynamic> json) {
    return Land(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      plantType: json['plant_type'] as String?,
      plantingDate: json['planting_date'] != null ? DateTime.parse(json['planting_date']) : null,
      harvestDate: json['harvest_date'] != null ? DateTime.parse(json['harvest_date']) : null,
      areaSize: (json['area_size'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'location': location,
      'plant_type': plantType,
      'planting_date': plantingDate?.toIso8601String(),
      'harvest_date': harvestDate?.toIso8601String(),
      'area_size': areaSize,
      'image_url': imageUrl,
    };
  }
}