# HEIC Converter Pro - Offline Version

## ✅ What You Get

A **simple, offline HEIC converter** with:
- ✅ No login required
- ✅ No database setup needed
- ✅ Works 100% offline
- ✅ In-app purchases for Pro upgrade
- ✅ Local storage only
- ✅ Ready to build APK

## 🚀 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Build APK
```bash
flutter build apk --release
```

### 3. Find Your APK
```
build/app/outputs/flutter-apk/app-release.apk
```

That's it! No Supabase, no database setup required.

## 📱 Features

### Free Users
- 50 free conversions
- HEIC to JPG/PNG/PDF
- Batch processing
- Save and share files

### Pro Users (In-App Purchase)
- Unlimited conversions
- No ads
- All features unlocked

## 🎯 How It Works

- **Local Storage**: All data stored on device using SharedPreferences
- **Offline**: No internet required for conversion
- **Privacy**: All processing done locally on device
- **Simple**: No account creation, no login

## 📦 What's Included

- Main screen with file picker
- Conversion screen with format/quality selection
- Pro upgrade screen with in-app purchases
- Settings screen for preferences
- Complete conversion engine

## 🔧 Configuration

### In-App Purchase Product IDs

Edit `lib/services/purchase_service.dart` to set your product IDs:
```dart
static const String proMonthlyId = 'your_monthly_id';
static const String proYearlyId = 'your_yearly_id';
static const String proLifetimeId = 'your_lifetime_id';
```

### AdMob (Optional)

Edit `lib/utils/app_constants.dart` for ad unit IDs.

## 📱 Testing

```bash
# Run on emulator/device
flutter run

# Test in-app purchases
# Use test account on Android
# Use sandbox account on iOS
```

## 🏗️ Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release
```

## 📊 App Structure

```
lib/
├── main.dart                          # App entry
├── screens/
│   ├── home/home_screen.dart         # Main screen (3 tabs)
│   ├── conversion/conversion_screen.dart
│   └── settings/settings_screen.dart
├── services/
│   ├── local_storage_service.dart    # SharedPreferences
│   ├── purchase_service.dart         # In-app purchases
│   └── conversion_service.dart       # File conversion
└── utils/
    └── app_constants.dart            # Constants
```

## ✨ Key Features

### Offline Conversion
- No internet needed
- Fast local processing
- Private and secure

### In-App Purchases
- Monthly subscription: $4.99
- Yearly subscription: $39.99 (save 33%)
- Lifetime purchase: $99.99

### Usage Tracking
- Counts conversions locally
- Free limit: 50 conversions
- Pro: Unlimited

### Settings
- Theme (Light/Dark/System)
- Default output format
- Default quality preset
- Reset app data option

## 🎨 Customization

### Change Colors
Edit `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue, // Change this
)
```

### Change Limits
Edit `lib/services/local_storage_service.dart`:
```dart
return count < 50; // Change limit here
```

### Change Pricing
Display only - actual prices set in Play Store/App Store

## 🆘 Common Issues

### In-app purchases not working?
- Test with Google Play test account
- Ensure products are set up in Play Console
- Use sandbox account for iOS

### Build errors?
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## 📄 License

MIT License - Free to use and modify

---

**Simple. Offline. Ready to build.** 🚀
