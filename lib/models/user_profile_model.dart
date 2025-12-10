class UserProfile {
  final String id;
  final String? username;
  final String? avatarUrl;
  final int level;
  final int gems;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    this.username,
    this.avatarUrl,
    this.level = 1,
    this.gems = 0,
    this.updatedAt,
  });

  /// Creates a UserProfile instance from a JSON map (Supabase response)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      level: json['level'] as int? ?? 1,
      gems: json['gems'] as int? ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Converts the UserProfile instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'level': level,
      'gems': gems,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Creates a copy of this profile with updated fields
  UserProfile copyWith({
    String? id,
    String? username,
    String? avatarUrl,
    int? level,
    int? gems,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      gems: gems ?? this.gems,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'UserProfile(id: $id, username: $username, level: $level, gems: $gems)';
}
