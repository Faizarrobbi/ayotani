enum DifficultyLevel { beginner, intermediate, advanced }

DifficultyLevel difficultyFromString(String value) {
  switch (value.toLowerCase()) {
    case 'beginner': return DifficultyLevel.beginner;
    case 'intermediate': return DifficultyLevel.intermediate;
    case 'advanced': return DifficultyLevel.advanced;
    default: return DifficultyLevel.beginner;
  }
}

class EducationalContent {
  final int id;
  final String title;
  final String description;
  final String? videoUrl; // Nullable for articles
  final String? thumbnailUrl;
  final DifficultyLevel difficulty;
  
  // New Fields
  final String contentType; // 'video' or 'article'
  final String? contentBody;
  final String? author;
  final DateTime? publishedAt;

  EducationalContent({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    this.thumbnailUrl,
    required this.difficulty,
    this.contentType = 'video',
    this.contentBody,
    this.author,
    this.publishedAt,
  });

  factory EducationalContent.fromJson(Map<String, dynamic> json) {
    return EducationalContent(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? '',
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      difficulty: difficultyFromString(json['difficulty'] ?? 'beginner'),
      contentType: json['content_type'] ?? 'video',
      contentBody: json['content_body'],
      author: json['author'] ?? 'Admin',
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at']) : null,
    );
  }
}