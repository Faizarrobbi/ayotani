enum TaskStatus { pending, completed }

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    return this == TaskStatus.pending ? 'Tertunda' : 'Selesai';
  }

  static TaskStatus fromString(String value) {
    return TaskStatus.values
        .firstWhere((e) => e.toString().split('.').last == value, orElse: () => TaskStatus.pending);
  }
}

class UserTask {
  final int id;
  final String profileId;
  final int dailyTaskId;
  final TaskStatus status;
  final DateTime? completedAt;

  UserTask({
    required this.id,
    required this.profileId,
    required this.dailyTaskId,
    this.status = TaskStatus.pending,
    this.completedAt,
  });

  /// Creates a UserTask instance from a JSON map (Supabase response)
  factory UserTask.fromJson(Map<String, dynamic> json) {
    return UserTask(
      id: json['id'] as int,
      profileId: json['profile_id'] as String,
      dailyTaskId: json['daily_task_id'] as int,
      status: TaskStatusExtension.fromString(json['status'] as String? ?? 'pending'),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  /// Converts the UserTask instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'daily_task_id': dailyTaskId,
      'status': status.toString().split('.').last,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// Creates a copy of this task with updated fields
  UserTask copyWith({
    int? id,
    String? profileId,
    int? dailyTaskId,
    TaskStatus? status,
    DateTime? completedAt,
  }) {
    return UserTask(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      dailyTaskId: dailyTaskId ?? this.dailyTaskId,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() =>
      'UserTask(id: $id, status: ${status.displayName}, completedAt: $completedAt)';
}
