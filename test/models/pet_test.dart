import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health_log/src/models/pet.dart';

void main() {
  group('Pet Model Tests', () {
    test('Pet can be created from JSON', () {
      final json = {
        'id': '123',
        'owner_id': '456',
        'name': 'Buddy',
        'species': 'dog',
        'breed': 'Golden Retriever',
        'dob': '2020-01-15',
        'sex': 'male',
        'weight_kg': 25.5,
        'created_at': '2023-01-01T00:00:00Z',
      };

      final pet = Pet.fromJson(json);

      expect(pet.id, '123');
      expect(pet.name, 'Buddy');
      expect(pet.species, 'dog');
      expect(pet.breed, 'Golden Retriever');
      expect(pet.weightKg, 25.5);
    });

    test('Pet can be converted to JSON', () {
      final pet = Pet(
        id: '123',
        ownerId: '456',
        name: 'Buddy',
        species: 'dog',
        breed: 'Golden Retriever',
        dateOfBirth: DateTime(2020, 1, 15),
        sex: 'male',
        weightKg: 25.5,
        createdAt: DateTime(2023, 1, 1),
      );

      final json = pet.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Buddy');
      expect(json['species'], 'dog');
      expect(json['breed'], 'Golden Retriever');
    });

    test('Pet age is calculated correctly', () {
      final pet = Pet(
        id: '123',
        ownerId: '456',
        name: 'Buddy',
        species: 'dog',
        dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 3)),
        createdAt: DateTime.now(),
      );

      expect(pet.ageInYears, 3);
    });

    test('Pet age is null when DOB is not set', () {
      final pet = Pet(
        id: '123',
        ownerId: '456',
        name: 'Buddy',
        species: 'dog',
        createdAt: DateTime.now(),
      );

      expect(pet.ageInYears, null);
    });
  });
}
