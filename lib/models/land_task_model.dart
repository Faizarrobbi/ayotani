class LandTask {
  final int id;
  final int landId;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String repeatType; // 'once', 'daily', 'weekly'
  bool isCompleted;

  LandTask({
    required this.id,
    required this.landId,
    required this.title,
    this.description,
    required this.dueDate,
    this.repeatType = 'once',
    this.isCompleted = false,
  });

  factory LandTask.fromJson(Map<String, dynamic> json) {
    return LandTask(
      id: json['id'] as int,
      landId: json['land_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueDate: DateTime.parse(json['due_date']),
      repeatType: json['repeat_type'] as String? ?? 'once',
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'land_id': landId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'repeat_type': repeatType,
      'is_completed': isCompleted,
    };
  }
}