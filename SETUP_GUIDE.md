# HEIC Converter Pro - Setup Guide

## Prerequisites

- Flutter SDK 3.16.0 or higher
- Android Studio or Xcode
- Supabase account

## 1. Supabase Setup

### Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Create a new project
3. Note your project URL and anon key

### Run Database Migration

1. Go to your Supabase dashboard
2. Navigate to SQL Editor
3. Copy and paste the contents of `supabase_migration.sql`
4. Run the migration

### Configure Authentication

1. In Supabase dashboard, go to Authentication > Providers
2. Enable Email provider
3. Disable email confirmations for development (optional)

### Create Storage Bucket

The migration script automatically creates the `heic-files` bucket with proper policies.

## 2. Update Configuration

Update the Supabase configuration in `lib/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

Or set environment variables:
```bash
export SUPABASE_URL='your_url'
export SUPABASE_ANON_KEY='your_key'
```

## 3. Install Dependencies

```bash
flutter pub get
```

## 4. Run the App

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Build APK
```bash
flutter build apk --release
```

### Build App Bundle
```bash
flutter build appbundle --release
```

## 5. Features

### Implemented Features

✅ Email/Password Authentication with Supabase
✅ User Profile Management
✅ HEIC to JPG/PNG/PDF Conversion
✅ Batch File Processing
✅ Conversion History (database structure ready)
✅ User Settings
✅ Free vs Pro User Tiers
✅ Usage Tracking
✅ Material 3 Design
✅ Dark/Light Theme Support

### Database Schema

- **profiles**: User profiles with conversion limits
- **conversions**: Conversion history and tracking
- **subscriptions**: Pro subscription management
- **user_settings**: User preferences and settings

### Row Level Security

All tables have RLS enabled with policies to ensure:
- Users can only access their own data
- Authenticated users required for all operations
- Secure file storage with user-specific access

## 6. Monetization (Optional)

To enable ads and in-app purchases:

1. Set up AdMob account and get ad unit IDs
2. Update IDs in `lib/utils/app_constants.dart`
3. Set up Google Play Billing
4. Configure product IDs

## 7. Testing

### Test User Flow

1. Sign up with email/password
2. Profile is automatically created
3. Try converting HEIC files
4. Check conversion limits
5. View profile and settings

### Database Testing

Check Supabase dashboard to verify:
- User profiles created on signup
- Conversions saved after conversion
- Settings saved when changed
- RLS policies enforced

## Troubleshooting

### Authentication Issues
- Verify Supabase URL and anon key
- Check email provider is enabled
- Check network connectivity

### Database Errors
- Verify migration ran successfully
- Check RLS policies are enabled
- Verify user is authenticated

### Build Errors
- Run `flutter clean`
- Run `flutter pub get`
- Check Flutter version: `flutter --version`

## Project Structure

```
lib/
├── config/              # Supabase configuration
├── models/              # Data models
│   ├── user_profile.dart
│   ├── conversion.dart
│   └── user_settings.dart
├── screens/             # UI screens
│   ├── auth/           # Authentication screens
│   ├── home/           # Home screen
│   ├── conversion/     # Conversion screens
│   ├── profile/        # Profile screen
│   └── settings/       # Settings screen
├── services/            # Business logic
│   ├── supabase_service.dart
│   └── conversion_service.dart
├── utils/               # Constants and utilities
├── widgets/             # Reusable widgets
└── main.dart           # App entry point
```

## Support

For issues or questions:
- Check Supabase logs in dashboard
- Enable Flutter debug logging
- Check device/emulator logs

---

**Built with Flutter & Supabase** 🚀
