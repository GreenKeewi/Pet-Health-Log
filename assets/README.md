# Assets

This directory contains static assets for the app.

## Structure

- `images/` - App images, logos, and illustrations
- `animations/` - Lottie animation files (.json)
- `icons/` - Custom app icons

## Adding Assets

1. Place files in the appropriate directory
2. Update `pubspec.yaml` to include new assets if needed
3. Reference in code using `'assets/path/to/file.png'`

## Required Assets

### Images
- App logo (various sizes for splash screen)
- Placeholder pet images
- Onboarding illustrations

### Animations
- Success animation (Lottie)
- Loading animations

### Icons
- App icon (iOS and Android - use flutter_launcher_icons package)

## Generating App Icons

Use the `flutter_launcher_icons` package:

```yaml
# Add to pubspec.yaml dev_dependencies
flutter_launcher_icons: ^0.13.1

# Add configuration
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
```

Then run:
```bash
flutter pub run flutter_launcher_icons
```
