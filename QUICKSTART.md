# Quick Start Guide

Get your HEIC Converter Pro app running in 5 minutes!

## Step 1: Install Dependencies

```bash
flutter pub get
```

## Step 2: Set Up Supabase

1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Copy your project URL and anon key
4. Go to SQL Editor and run the migration:
   - Open `supabase_migration.sql`
   - Copy all content
   - Paste in SQL Editor
   - Click "Run"

## Step 3: Update Configuration

Edit `lib/config/supabase_config.dart`:

```dart
static const String supabaseUrl = 'YOUR_PROJECT_URL_HERE';
static const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';
```

## Step 4: Run the App

```bash
flutter run
```

That's it! Your app is now running with:

✅ Working authentication
✅ User profiles
✅ Secure database
✅ File conversion
✅ Beautiful UI

## What You Get

### Free Users
- 50 free conversions
- Email/password authentication
- Save and share converted files
- Dark/light mode

### Pro Features (Database Ready)
- Unlimited conversions
- No ads
- Priority support
- Advanced settings

## Next Steps

1. Test signup and login
2. Try converting a HEIC file
3. Check your Supabase dashboard to see data
4. Customize the app for your needs

## Need Help?

- Check `SETUP_GUIDE.md` for detailed documentation
- Review `README.md` for full feature list
- Visit Supabase documentation for database help

## Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release
```

Your APK will be in: `build/app/outputs/flutter-apk/app-release.apk`

---

**Happy Converting!** 🚀
