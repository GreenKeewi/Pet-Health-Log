class Attachment {
  final String id;
  final String? visitId;
  final String? petId;
  final String? ownerId;
  final String url;
  final String? mimeType;
  final String? extractedText;
  final DateTime createdAt;

  Attachment({
    required this.id,
    this.visitId,
    this.petId,
    this.ownerId,
    required this.url,
    this.mimeType,
    this.extractedText,
    required this.createdAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String,
      visitId: json['visit_id'] as String?,
      petId: json['pet_id'] as String?,
      ownerId: json['owner_id'] as String?,
      url: json['url'] as String,
      mimeType: json['mime_type'] as String?,
      extractedText: json['extracted_text'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'pet_id': petId,
      'owner_id': ownerId,
      'url': url,
      'mime_type': mimeType,
      'extracted_text': extractedText,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
