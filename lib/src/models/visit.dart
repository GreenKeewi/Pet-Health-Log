class Visit {
  final String id;
  final String petId;
  final String ownerId;
  final String? clinicName;
  final DateTime? visitDate;
  final String? visitType; // checkup, vaccine, dental, emergency, grooming, other
  final double? totalCost;
  final String? notes;
  final String? aiSummary;
  final Map<String, dynamic>? aiTags;
  final DateTime createdAt;

  Visit({
    required this.id,
    required this.petId,
    required this.ownerId,
    this.clinicName,
    this.visitDate,
    this.visitType,
    this.totalCost,
    this.notes,
    this.aiSummary,
    this.aiTags,
    required this.createdAt,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      ownerId: json['owner_id'] as String,
      clinicName: json['clinic_name'] as String?,
      visitDate: json['visit_date'] != null 
          ? DateTime.parse(json['visit_date']) 
          : null,
      visitType: json['visit_type'] as String?,
      totalCost: json['total_cost'] != null 
          ? (json['total_cost'] as num).toDouble() 
          : null,
      notes: json['notes'] as String?,
      aiSummary: json['ai_summary'] as String?,
      aiTags: json['ai_tags'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pet_id': petId,
      'owner_id': ownerId,
      'clinic_name': clinicName,
      'visit_date': visitDate?.toIso8601String(),
      'visit_type': visitType,
      'total_cost': totalCost,
      'notes': notes,
      'ai_summary': aiSummary,
      'ai_tags': aiTags,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
