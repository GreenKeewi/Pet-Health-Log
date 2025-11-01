import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../models/reminder.dart';
import '../../../models/pet.dart';
import '../../../services/supabase_service.dart';
import '../../../utils/constants.dart';

class AddReminderScreen extends StatefulWidget {
  final Pet pet;

  const AddReminderScreen({super.key, required this.pet});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _supabaseService = SupabaseService();

  DateTime? _remindAt;
  String _recurrence = 'none';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null) {
      if (!mounted) return;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
      );

      if (pickedTime != null) {
        setState(() {
          _remindAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_remindAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a reminder date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = _supabaseService.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final reminder = Reminder(
        id: const Uuid().v4(),
        petId: widget.pet.id,
        ownerId: userId,
        title: _titleController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        remindAt: _remindAt!,
        recurrence: _recurrence,
        isDone: false,
        createdAt: DateTime.now(),
      );

      await _supabaseService.createReminder(reminder);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder created successfully!')),
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
        title: Text('Add Reminder for ${widget.pet.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Reminder Title *',
                  hintText: 'e.g., Annual vaccine due',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Additional details',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Date and time picker
              InkWell(
                onTap: _selectDateTime,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Remind me on *',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _remindAt != null
                        ? '${_remindAt!.day}/${_remindAt!.month}/${_remindAt!.year} at ${_remindAt!.hour.toString().padLeft(2, '0')}:${_remindAt!.minute.toString().padLeft(2, '0')}'
                        : 'Select date and time',
                    style: _remindAt != null
                        ? null
                        : TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recurrence
              DropdownButtonFormField<String>(
                value: _recurrence,
                decoration: const InputDecoration(
                  labelText: 'Recurrence',
                ),
                items: AppConstants.recurrenceOptions
                    .map((recurrence) => DropdownMenuItem(
                          value: recurrence,
                          child: Text(recurrence.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _recurrence = value);
                  }
                },
              ),
              const SizedBox(height: 32),

              // Info card
              Card(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You\'ll receive a push notification at the scheduled time',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveReminder,
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
                    : const Text('Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
