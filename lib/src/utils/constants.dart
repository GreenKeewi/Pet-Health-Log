class AppConstants {
  // API endpoints
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );
  static const String aiServiceUrl = String.fromEnvironment(
    'AI_SERVICE_URL',
    defaultValue: 'https://your-functions.supabase.co/functions/v1',
  );

  // Species options
  static const List<String> speciesOptions = ['dog', 'cat', 'other'];

  // Visit types
  static const List<String> visitTypes = [
    'checkup',
    'vaccine',
    'dental',
    'emergency',
    'grooming',
    'other',
  ];

  // Recurrence options
  static const List<String> recurrenceOptions = [
    'none',
    'yearly',
    'custom',
  ];

  // Subscription tiers
  static const String freeTier = 'free';
  static const String proTier = 'petlog.pro.monthly';
  static const String familyTier = 'petlog.family.monthly';
  static const String lifetimeTier = 'petlog.lifetime';

  // Free tier limits
  static const int freePetLimit = 1;
  static const int freeAiCallLimit = 3;

  // Pricing
  static const double proPriceMonthly = 4.99;
  static const double familyPriceMonthly = 9.99;
  static const double lifetimePrice = 39.99;
}
