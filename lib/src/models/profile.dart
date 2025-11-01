class Profile {
  final String id;
  final String? displayName;
  final String? email;
  final DateTime createdAt;

  Profile({
    required this.id,
    this.displayName,
    this.email,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      displayName: json['display_name'] as String?,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'email': email,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
