class Reminder {
  final String id;
  final String petId;
  final String ownerId;
  final String title;
  final String? note;
  final DateTime remindAt;
  final String recurrence; // none, yearly, custom
  final bool isDone;
  final DateTime createdAt;

  Reminder({
    required this.id,
    required this.petId,
    required this.ownerId,
    required this.title,
    this.note,
    required this.remindAt,
    required this.recurrence,
    this.isDone = false,
    required this.createdAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      ownerId: json['owner_id'] as String,
      title: json['title'] as String,
      note: json['note'] as String?,
      remindAt: DateTime.parse(json['remind_at'] as String),
      recurrence: json['recurrence'] as String,
      isDone: json['is_done'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pet_id': petId,
      'owner_id': ownerId,
      'title': title,
      'note': note,
      'remind_at': remindAt.toIso8601String(),
      'recurrence': recurrence,
      'is_done': isDone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
