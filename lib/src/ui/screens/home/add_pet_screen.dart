import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/pet.dart';
import '../../../services/supabase_service.dart';
import '../../../utils/constants.dart';
import 'package:uuid/uuid.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _weightController = TextEditingController();
  final _supabaseService = SupabaseService();
  final _imagePicker = ImagePicker();

  String _selectedSpecies = 'dog';
  String? _selectedSex;
  DateTime? _dateOfBirth;
  String? _avatarUrl;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      // In a real app, upload to Supabase Storage here
      // For now, just store the local path
      setState(() {
        _avatarUrl = image.path;
      });
    }
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = _supabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final pet = Pet(
        id: const Uuid().v4(),
        ownerId: userId,
        name: _nameController.text.trim(),
        species: _selectedSpecies,
        breed: _breedController.text.trim().isEmpty
            ? null
            : _breedController.text.trim(),
        dateOfBirth: _dateOfBirth,
        sex: _selectedSex,
        avatarUrl: _avatarUrl,
        weightKg: _weightController.text.trim().isEmpty
            ? null
            : double.tryParse(_weightController.text.trim()),
        createdAt: DateTime.now(),
      );

      await _supabaseService.createPet(pet);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pet added successfully!')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: _avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              _avatarUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to add photo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'e.g., Buddy',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pet\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Species
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: const InputDecoration(
                  labelText: 'Species *',
                ),
                items: AppConstants.speciesOptions
                    .map((species) => DropdownMenuItem(
                          value: species,
                          child: Text(species.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedSpecies = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Breed
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  hintText: 'e.g., Golden Retriever',
                ),
              ),
              const SizedBox(height: 16),

              // Date of Birth
              InkWell(
                onTap: _selectDateOfBirth,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _dateOfBirth != null
                        ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                        : 'Select date',
                    style: _dateOfBirth != null
                        ? null
                        : TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sex
              DropdownButtonFormField<String>(
                value: _selectedSex,
                decoration: const InputDecoration(
                  labelText: 'Sex',
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() => _selectedSex = value);
                },
              ),
              const SizedBox(height: 16),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  hintText: 'e.g., 25.5',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _isLoading ? null : _savePet,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save Pet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
