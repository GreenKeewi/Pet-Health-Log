# Pet Health Log

> Smart care for your furry family

A friendly, privacy-first iOS/Android app that helps pet owners track vet visits, medications, vaccines, weight, costs, and get AI-generated visit summaries, trend insights, and smart reminders.

## Features

- 🐾 **Pet Management**: Track multiple pets with photos, breed info, and health data
- 📋 **Visit Tracking**: Record vet visits with OCR document scanning
- 🤖 **AI Summaries**: Get plain-language summaries of vet visits
- 🔔 **Smart Reminders**: Never miss vaccines, medications, or checkups
- 📊 **Health Timeline**: View complete medical history at a glance
- 📄 **PDF Export**: Share records with vets or family
- 💳 **Flexible Plans**: Free, Pro, and Family subscriptions

## Tech Stack

- **Mobile**: Flutter (cross-platform iOS/Android)
- **Backend**: Supabase (PostgreSQL + Auth + Storage)
- **AI**: OpenAI GPT-4o-mini
- **OCR**: Google ML Kit Text Recognition
- **Notifications**: Firebase Cloud Messaging
- **Payments**: RevenueCat
- **Analytics**: PostHog / Mixpanel

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Xcode (for iOS development)
- Android Studio (for Android development)
- Supabase account
- OpenAI API key
- Firebase project
- RevenueCat account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/GreenKeewi/Pet-Health-Log.git
   cd Pet-Health-Log
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a new Supabase project
   - Run the migration: `supabase/migrations/001_initial_schema.sql`
   - Copy your Supabase URL and anon key

4. **Set up environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   AI_SERVICE_URL=your_supabase_functions_url
   OPENAI_API_KEY=your_openai_api_key
   ```

5. **Deploy Supabase Functions**
   ```bash
   # Install Supabase CLI
   npm install -g supabase
   
   # Deploy functions
   supabase functions deploy ai_extract_receipt
   supabase functions deploy ai_summarize_visit
   supabase functions deploy revenuecat_webhook
   ```

6. **Configure Firebase**
   - Add your Firebase configuration files:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`

7. **Set up RevenueCat**
   - Create products in App Store Connect and Google Play Console
   - Configure products in RevenueCat dashboard
   - Update product IDs in `lib/src/utils/constants.dart`

### Running the App

**iOS**
```bash
flutter run -d ios
```

**Android**
```bash
flutter run -d android
```

**Build for Release**
```bash
# iOS
flutter build ios --release

# Android
flutter build apk --release
```

## Project Structure

```
pet_health_log/
├── android/              # Android native code
├── ios/                  # iOS native code
├── lib/
│   ├── main.dart        # App entry point
│   └── src/
│       ├── models/      # Data models
│       ├── services/    # Business logic services
│       ├── ui/          # UI screens and widgets
│       │   ├── screens/
│       │   └── widgets/
│       └── utils/       # Utilities and constants
├── functions/           # Supabase Edge Functions
│   ├── ai_extract_receipt/
│   ├── ai_summarize_visit/
│   └── revenuecat_webhook/
├── supabase/
│   └── migrations/      # Database migrations
└── pubspec.yaml         # Flutter dependencies
```

## Database Schema

The app uses PostgreSQL via Supabase with the following tables:
- `profiles` - User profiles
- `pets` - Pet information
- `visits` - Veterinary visits
- `attachments` - Documents and receipts
- `reminders` - Medication and appointment reminders
- `subscriptions` - RevenueCat subscription data

See `supabase/migrations/001_initial_schema.sql` for the complete schema.

## API Endpoints

### Serverless Functions

- `POST /ai/extract_receipt` - Extract data from vet receipts using OCR + AI
- `POST /ai/summarize_visit` - Generate plain-language visit summaries
- `POST /webhook/revenuecat` - Handle RevenueCat subscription events

## Subscription Tiers

- **Free**: 1 pet, manual logs, basic reminders
- **Pro** ($4.99/mo): Multi-pet, AI summaries, PDF export
- **Family** ($9.99/mo): Shared access, up to 10 pets
- **Lifetime** ($39.99): All Pro features forever

## Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Format Code
```bash
flutter format .
```

## CI/CD

GitHub Actions workflows are configured for:
- Running tests on PR
- Building Android APK
- Publishing to TestFlight (iOS)
- Code quality checks

## Security & Privacy

- All data is encrypted at rest
- Row Level Security (RLS) enabled in Supabase
- API keys stored securely (never in client code)
- GDPR-compliant data export and deletion
- Minimal data collection

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is proprietary software. All rights reserved.

## Support

For support, email support@pethealthlog.com or open an issue in this repository.

## Roadmap

- [ ] Multi-language support
- [ ] Apple Watch companion app
- [ ] Vet clinic integration
- [ ] Pet insurance integration
- [ ] Health trend predictions
- [ ] Community features

## Acknowledgments

- Design inspiration from modern health tracking apps
- Icons from Material Design
- Pet health guidelines from AVMA

---

Made with ❤️ for pet owners everywhere
