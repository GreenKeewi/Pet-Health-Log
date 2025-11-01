import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String species;
  final String? breed;
  final int? age;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const PetCard({
    super.key,
    required this.name,
    required this.species,
    this.breed,
    this.age,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                child: avatarUrl == null
                    ? const Icon(Icons.pets, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${species.toUpperCase()}${breed != null ? ' • $breed' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (age != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$age years old',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
