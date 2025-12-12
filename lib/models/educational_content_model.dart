enum DifficultyLevel { beginner, intermediate, advanced }

DifficultyLevel difficultyFromString(String value) {
  switch (value.toLowerCase()) {
    case 'beginner':
      return DifficultyLevel.beginner;
    case 'intermediate':
      return DifficultyLevel.intermediate;
    case 'advanced':
      return DifficultyLevel.advanced;
    default:
      return DifficultyLevel.beginner;
  }
}

class EducationalContent {
  final int id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl;
  final DifficultyLevel difficulty;

  EducationalContent({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.difficulty,
  });

  factory EducationalContent.fromJson(Map<String, dynamic> json) {
    return EducationalContent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],          // 🔴 PENTING
      thumbnailUrl: json['thumbnail_url'],
      difficulty: difficultyFromString(json['difficulty']),
    );
  }
}