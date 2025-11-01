# Fonts

This directory should contain the Inter font family files:

- `Inter-Regular.ttf`
- `Inter-Bold.ttf`

## Download Fonts

Download Inter font from: https://fonts.google.com/specimen/Inter

Place the font files in this directory to match the configuration in `pubspec.yaml`.

## Alternative

You can also use the Google Fonts package instead:

```dart
import 'package:google_fonts/google_fonts.dart';

// In your theme
textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
```
