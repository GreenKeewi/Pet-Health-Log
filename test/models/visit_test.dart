import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health_log/src/models/visit.dart';

void main() {
  group('Visit Model Tests', () {
    test('Visit can be created from JSON', () {
      final json = {
        'id': '123',
        'pet_id': '456',
        'owner_id': '789',
        'clinic_name': 'Happy Paws Clinic',
        'visit_date': '2025-11-01T10:00:00Z',
        'visit_type': 'checkup',
        'total_cost': 150.00,
        'notes': 'Annual checkup',
        'ai_summary': 'Buddy had a routine checkup',
        'ai_tags': {
          'medications': ['none'],
          'next_steps': ['Schedule next visit in 1 year']
        },
        'created_at': '2025-11-01T10:00:00Z',
      };

      final visit = Visit.fromJson(json);

      expect(visit.id, '123');
      expect(visit.petId, '456');
      expect(visit.clinicName, 'Happy Paws Clinic');
      expect(visit.visitType, 'checkup');
      expect(visit.totalCost, 150.00);
      expect(visit.aiSummary, 'Buddy had a routine checkup');
    });

    test('Visit can be converted to JSON', () {
      final visit = Visit(
        id: '123',
        petId: '456',
        ownerId: '789',
        clinicName: 'Happy Paws Clinic',
        visitDate: DateTime(2025, 11, 1, 10, 0),
        visitType: 'checkup',
        totalCost: 150.00,
        notes: 'Annual checkup',
        aiSummary: 'Buddy had a routine checkup',
        aiTags: {
          'medications': ['none'],
          'next_steps': ['Schedule next visit in 1 year']
        },
        createdAt: DateTime(2025, 11, 1, 10, 0),
      );

      final json = visit.toJson();

      expect(json['id'], '123');
      expect(json['clinic_name'], 'Happy Paws Clinic');
      expect(json['visit_type'], 'checkup');
      expect(json['total_cost'], 150.00);
    });

    test('Visit handles null fields correctly', () {
      final visit = Visit(
        id: '123',
        petId: '456',
        ownerId: '789',
        createdAt: DateTime.now(),
      );

      expect(visit.clinicName, null);
      expect(visit.visitDate, null);
      expect(visit.visitType, null);
      expect(visit.totalCost, null);
      expect(visit.notes, null);
      expect(visit.aiSummary, null);
      expect(visit.aiTags, null);
    });
  });
}
