import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health_log/src/models/reminder.dart';

void main() {
  group('Reminder Model Tests', () {
    test('Reminder can be created from JSON', () {
      final json = {
        'id': '123',
        'pet_id': '456',
        'owner_id': '789',
        'title': 'Vaccine due',
        'note': 'Annual rabies vaccine',
        'remind_at': '2025-12-01T10:00:00Z',
        'recurrence': 'yearly',
        'is_done': false,
        'created_at': '2023-01-01T00:00:00Z',
      };

      final reminder = Reminder.fromJson(json);

      expect(reminder.id, '123');
      expect(reminder.title, 'Vaccine due');
      expect(reminder.recurrence, 'yearly');
      expect(reminder.isDone, false);
    });

    test('Reminder can be converted to JSON', () {
      final reminder = Reminder(
        id: '123',
        petId: '456',
        ownerId: '789',
        title: 'Vaccine due',
        note: 'Annual rabies vaccine',
        remindAt: DateTime(2025, 12, 1, 10, 0),
        recurrence: 'yearly',
        isDone: false,
        createdAt: DateTime(2023, 1, 1),
      );

      final json = reminder.toJson();

      expect(json['id'], '123');
      expect(json['title'], 'Vaccine due');
      expect(json['recurrence'], 'yearly');
      expect(json['is_done'], false);
    });
  });
}
