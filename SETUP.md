# Pet Health Log - Setup Guide

Complete setup guide for developers working on Pet Health Log.

## Project Overview

Pet Health Log is a Flutter-based mobile application for tracking pet health records, vet visits, medications, and reminders. It uses:
- **Frontend**: Flutter (iOS & Android)
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **AI**: OpenAI GPT-4o-mini
- **Payments**: RevenueCat
- **Notifications**: Firebase Cloud Messaging

## Prerequisites

1. **Flutter SDK** (3.0.0+)
   ```bash
   flutter --version
   flutter doctor
   ```

2. **Development Tools**
   - Xcode (for iOS)
   - Android Studio (for Android)
   - VS Code or Android Studio IDE

3. **Accounts Required**
   - Supabase account
   - OpenAI account (API key)
   - Firebase account
   - RevenueCat account
   - Apple Developer account (for iOS)
   - Google Play Developer account (for Android)

## Initial Setup

### 1. Clone and Install

```bash
git clone https://github.com/GreenKeewi/Pet-Health-Log.git
cd Pet-Health-Log
flutter pub get
```

### 2. Supabase Setup

1. Create a new Supabase project at https://supabase.com
2. Go to SQL Editor and run the migration:
   ```sql
   -- Copy contents from supabase/migrations/001_initial_schema.sql
   ```
3. Create storage bucket:
   - Name: `attachments`
   - Public: No (private)
   - Configure RLS policies for authenticated users

4. Get your credentials:
   - Project URL: `https://xxx.supabase.co`
   - Anon Key: From Settings > API

### 3. Environment Configuration

Create `.env` file in project root:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
AI_SERVICE_URL=https://your-project.supabase.co/functions/v1
OPENAI_API_KEY=sk-your-openai-key
```

**Important**: Never commit `.env` to version control!

### 4. Deploy Supabase Functions

```bash
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Set secrets
supabase secrets set OPENAI_API_KEY=your-key

# Deploy functions
supabase functions deploy ai_extract_receipt
supabase functions deploy ai_summarize_visit
supabase functions deploy revenuecat_webhook
```

### 5. Firebase Setup

1. Create Firebase project at https://console.firebase.google.com
2. Add iOS app:
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`
3. Add Android app:
   - Download `google-services.json`
   - Place in `android/app/`
4. Enable Cloud Messaging in Firebase Console

### 6. RevenueCat Setup

1. Create account at https://revenuecat.com
2. Create app in RevenueCat dashboard
3. Configure products:
   - `petlog.pro.monthly` - $4.99/month
   - `petlog.family.monthly` - $9.99/month
   - `petlog.lifetime` - $39.99 one-time
4. Get API key from RevenueCat
5. Set up webhook URL pointing to your Supabase function

## Running the App

### Development Mode

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# With environment variables
flutter run --dart-define=SUPABASE_URL=https://... --dart-define=SUPABASE_ANON_KEY=...
```

### Build for Production

**iOS**
```bash
flutter build ios --release
# Then open ios/Runner.xcworkspace in Xcode to archive
```

**Android**
```bash
flutter build apk --release
# Or for app bundle
flutter build appbundle --release
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/pet_test.dart
```

## Code Quality

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Fix analysis issues
dart fix --apply
```

## Common Development Tasks

### Adding New Screens

1. Create screen file in `lib/src/ui/screens/`
2. Add route in `main.dart`
3. Navigate using `Navigator.pushNamed(context, '/route')`

### Adding New Models

1. Create model file in `lib/src/models/`
2. Implement `fromJson` and `toJson` methods
3. Add corresponding database table in migration
4. Add service methods in `SupabaseService`

### Working with Supabase

```dart
// Get instance
final supabase = SupabaseService();

// Check auth
if (supabase.isAuthenticated) {
  final user = supabase.currentUser;
}

// Query data
final pets = await supabase.getPets();
```

### Using AI Services

```dart
final aiService = AIService(baseUrl: AppConstants.aiServiceUrl);

// Extract receipt data
final extractedData = await aiService.extractReceipt(
  extractedText: ocrText,
);

// Generate visit summary
final summary = await aiService.summarizeVisit(
  pet: petData,
  visit: visitData,
);
```

## Troubleshooting

### Flutter Issues

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### iOS Build Issues

```bash
cd ios
pod install
cd ..
flutter run -d ios
```

### Android Build Issues

```bash
cd android
./gradlew clean
cd ..
flutter run -d android
```

### Supabase Connection Issues

- Verify SUPABASE_URL and SUPABASE_ANON_KEY
- Check RLS policies are configured
- Ensure user is authenticated before queries

## Project Structure

```
pet_health_log/
├── lib/
│   ├── main.dart                 # App entry point
│   └── src/
│       ├── models/              # Data models
│       ├── services/            # Business logic
│       ├── ui/
│       │   ├── screens/        # Full-page screens
│       │   └── widgets/        # Reusable widgets
│       └── utils/              # Helpers & constants
├── test/                        # Unit & widget tests
├── functions/                   # Supabase Edge Functions
├── supabase/
│   └── migrations/             # Database migrations
└── assets/                     # Images, fonts, animations
```

## Next Steps

1. Download and add Inter font files to `fonts/`
2. Create app icon and add to `assets/icons/`
3. Set up CI/CD with GitHub Actions
4. Configure app signing for iOS and Android
5. Submit to TestFlight and Play Console beta

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [RevenueCat Documentation](https://docs.revenuecat.com)
- [Firebase Documentation](https://firebase.google.com/docs)

## Support

For questions or issues:
- Open an issue on GitHub
- Check existing documentation
- Review the codebase comments

---

Happy coding! 🐾
