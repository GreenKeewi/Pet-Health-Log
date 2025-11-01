class Pet {
  final String id;
  final String ownerId;
  final String name;
  final String species; // dog, cat, other
  final String? breed;
  final DateTime? dateOfBirth;
  final String? sex;
  final String? avatarUrl;
  final double? weightKg;
  final DateTime createdAt;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    this.breed,
    this.dateOfBirth,
    this.sex,
    this.avatarUrl,
    this.weightKg,
    required this.createdAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String?,
      dateOfBirth: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      sex: json['sex'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      weightKg: json['weight_kg'] != null 
          ? (json['weight_kg'] as num).toDouble() 
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'species': species,
      'breed': breed,
      'dob': dateOfBirth?.toIso8601String(),
      'sex': sex,
      'avatar_url': avatarUrl,
      'weight_kg': weightKg,
      'created_at': createdAt.toIso8601String(),
    };
  }

  int? get ageInYears {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
}
