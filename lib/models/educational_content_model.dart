enum DifficultyLevel { beginner, intermediate, advanced }

extension DifficultyLevelExtension on DifficultyLevel {
  String get displayName {
    switch (this) {
      case DifficultyLevel.beginner:
        return 'Pemula';
      case DifficultyLevel.intermediate:
        return 'Menengah';
      case DifficultyLevel.advanced:
        return 'Lanjutan';
    }
  }

  static DifficultyLevel fromString(String value) {
    return DifficultyLevel.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => DifficultyLevel.beginner,
    );
  }
}

class EducationalContent {
  final int id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnailUrl;
  final DifficultyLevel difficulty;
  final DateTime? createdAt;

  EducationalContent({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    this.difficulty = DifficultyLevel.beginner,
    this.createdAt,
  });

  /// Creates an EducationalContent instance from a JSON map (Supabase response)
  factory EducationalContent.fromJson(Map<String, dynamic> json) {
    return EducationalContent(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      videoUrl: json['video_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      difficulty: DifficultyLevelExtension.fromString(
        json['difficulty'] as String? ?? 'Beginner',
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Converts the EducationalContent instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'difficulty': difficulty.toString().split('.').last,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() => 'EducationalContent(id: $id, title: $title, level: ${difficulty.displayName})';
}
