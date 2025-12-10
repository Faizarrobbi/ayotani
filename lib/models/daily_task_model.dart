enum TaskCategory { health, watering, fertilizing, harvesting, other }

extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.health:
        return 'Kesehatan Tanaman';
      case TaskCategory.watering:
        return 'Penyiraman';
      case TaskCategory.fertilizing:
        return 'Pemupukan';
      case TaskCategory.harvesting:
        return 'Pemanenan';
      case TaskCategory.other:
        return 'Lainnya';
    }
  }

  static TaskCategory fromString(String value) {
    return TaskCategory.values
        .firstWhere((e) => e.toString().split('.').last == value, orElse: () => TaskCategory.other);
  }
}

class DailyTask {
  final int id;
  final String title;
  final String? description;
  final int rewardGems;
  final TaskCategory category;
  final DateTime? createdAt;

  DailyTask({
    required this.id,
    required this.title,
    this.description,
    this.rewardGems = 10,
    required this.category,
    this.createdAt,
  });

  /// Creates a DailyTask instance from a JSON map (Supabase response)
  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      rewardGems: json['reward_gems'] as int? ?? 10,
      category: TaskCategoryExtension.fromString(json['category'] as String? ?? 'other'),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Converts the DailyTask instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reward_gems': rewardGems,
      'category': category.toString().split('.').last,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() => 'DailyTask(id: $id, title: $title, reward: $rewardGems gems)';
}
