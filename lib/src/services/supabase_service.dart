import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pet.dart';
import '../models/visit.dart';
import '../models/reminder.dart';
import '../models/attachment.dart';
import '../models/profile.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // Auth methods
  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Profile methods
  Future<Profile?> getProfile(String userId) async {
    final response = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    
    if (response == null) return null;
    return Profile.fromJson(response);
  }

  Future<Profile> createProfile(Profile profile) async {
    final response = await client
        .from('profiles')
        .insert(profile.toJson())
        .select()
        .single();
    
    return Profile.fromJson(response);
  }

  // Pet methods
  Future<List<Pet>> getPets() async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await client
        .from('pets')
        .select()
        .eq('owner_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Pet.fromJson(json)).toList();
  }

  Future<Pet> createPet(Pet pet) async {
    final response = await client
        .from('pets')
        .insert(pet.toJson())
        .select()
        .single();
    
    return Pet.fromJson(response);
  }

  Future<Pet> updatePet(Pet pet) async {
    final response = await client
        .from('pets')
        .update(pet.toJson())
        .eq('id', pet.id)
        .select()
        .single();
    
    return Pet.fromJson(response);
  }

  Future<void> deletePet(String petId) async {
    await client.from('pets').delete().eq('id', petId);
  }

  // Visit methods
  Future<List<Visit>> getVisits(String petId) async {
    final response = await client
        .from('visits')
        .select()
        .eq('pet_id', petId)
        .order('visit_date', ascending: false);

    return (response as List).map((json) => Visit.fromJson(json)).toList();
  }

  Future<Visit> createVisit(Visit visit) async {
    final response = await client
        .from('visits')
        .insert(visit.toJson())
        .select()
        .single();
    
    return Visit.fromJson(response);
  }

  Future<Visit> updateVisit(Visit visit) async {
    final response = await client
        .from('visits')
        .update(visit.toJson())
        .eq('id', visit.id)
        .select()
        .single();
    
    return Visit.fromJson(response);
  }

  // Reminder methods
  Future<List<Reminder>> getReminders(String petId) async {
    final response = await client
        .from('reminders')
        .select()
        .eq('pet_id', petId)
        .order('remind_at', ascending: true);

    return (response as List).map((json) => Reminder.fromJson(json)).toList();
  }

  Future<List<Reminder>> getUpcomingReminders() async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final now = DateTime.now().toIso8601String();
    final response = await client
        .from('reminders')
        .select()
        .eq('owner_id', userId)
        .eq('is_done', false)
        .gte('remind_at', now)
        .order('remind_at', ascending: true)
        .limit(10);

    return (response as List).map((json) => Reminder.fromJson(json)).toList();
  }

  Future<Reminder> createReminder(Reminder reminder) async {
    final response = await client
        .from('reminders')
        .insert(reminder.toJson())
        .select()
        .single();
    
    return Reminder.fromJson(response);
  }

  Future<Reminder> updateReminder(Reminder reminder) async {
    final response = await client
        .from('reminders')
        .update(reminder.toJson())
        .eq('id', reminder.id)
        .select()
        .single();
    
    return Reminder.fromJson(response);
  }

  // Attachment methods
  Future<List<Attachment>> getAttachments(String visitId) async {
    final response = await client
        .from('attachments')
        .select()
        .eq('visit_id', visitId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Attachment.fromJson(json)).toList();
  }

  Future<String> uploadFile(String path, List<int> bytes) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final filePath = '$userId/$path';
    await client.storage.from('attachments').uploadBinary(filePath, bytes);
    
    return client.storage.from('attachments').getPublicUrl(filePath);
  }

  Future<Attachment> createAttachment(Attachment attachment) async {
    final response = await client
        .from('attachments')
        .insert(attachment.toJson())
        .select()
        .single();
    
    return Attachment.fromJson(response);
  }
}
