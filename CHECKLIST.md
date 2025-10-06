# ✅ Setup Checklist

Use this checklist to get your HEIC Converter Pro app running!

## 📋 Pre-Setup

- [ ] Flutter SDK installed (3.16.0+)
- [ ] Android Studio or VS Code installed
- [ ] Android emulator or device ready
- [ ] Internet connection available

## 🗄️ Supabase Setup (5 minutes)

- [ ] Go to [supabase.com](https://supabase.com)
- [ ] Create free account
- [ ] Create new project
- [ ] Wait for project to initialize (~2 minutes)
- [ ] Copy Project URL
- [ ] Copy Anon Key (from Settings > API)

## 💾 Database Setup (2 minutes)

- [ ] Open Supabase dashboard
- [ ] Navigate to SQL Editor
- [ ] Open `supabase_migration.sql` file
- [ ] Copy entire contents
- [ ] Paste in SQL Editor
- [ ] Click "Run" button
- [ ] Verify tables created (Check Table Editor)

## ⚙️ App Configuration (1 minute)

- [ ] Open `lib/config/supabase_config.dart`
- [ ] Replace `supabaseUrl` with your URL
- [ ] Replace `supabaseAnonKey` with your key
- [ ] Save file

## 📦 Install Dependencies (1 minute)

- [ ] Open terminal in project directory
- [ ] Run `flutter pub get`
- [ ] Wait for packages to download

## 🚀 Run the App (1 minute)

- [ ] Connect device or start emulator
- [ ] Run `flutter run`
- [ ] Wait for app to build and launch

## ✨ Test Features (5 minutes)

### Authentication
- [ ] See splash screen
- [ ] Navigate to login screen
- [ ] Click "Sign Up"
- [ ] Enter name, email, password
- [ ] Successfully create account
- [ ] Redirect to home screen

### Home Screen
- [ ] See your name in profile tab
- [ ] View conversion stats
- [ ] Check remaining conversions (should be 50)

### Conversion
- [ ] Click "Select Files"
- [ ] Choose output format (JPG/PNG/PDF)
- [ ] Select quality
- [ ] Click "Start Conversion"
- [ ] See progress
- [ ] View results

### Profile
- [ ] View profile information
- [ ] Check conversion count
- [ ] See Pro upgrade option

### Settings
- [ ] Change theme
- [ ] Change default format
- [ ] Change quality preset
- [ ] Settings saved

### Database Verification
- [ ] Open Supabase dashboard
- [ ] Check Table Editor
- [ ] See your profile in `profiles` table
- [ ] See conversions in `conversions` table
- [ ] See settings in `user_settings` table

## 🔧 Customization (Optional)

- [ ] Update app colors in `main.dart`
- [ ] Change conversion limits in `app_constants.dart`
- [ ] Update app name in `pubspec.yaml`
- [ ] Add app icon
- [ ] Customize splash screen

## 📱 Build for Release (Optional)

- [ ] Run `flutter build apk --release`
- [ ] Find APK in `build/app/outputs/flutter-apk/`
- [ ] Test APK on device
- [ ] Sign APK for Play Store (if publishing)

## 🎉 Success Criteria

You're done when you can:
- ✅ Sign up new users
- ✅ Login existing users
- ✅ Convert HEIC files
- ✅ Save and share results
- ✅ Change settings
- ✅ See data in Supabase dashboard
- ✅ Build APK successfully

## 🆘 Troubleshooting

### Can't connect to Supabase?
- Check URL and key are correct
- Verify internet connection
- Check Supabase project is active

### App won't build?
- Run `flutter clean`
- Run `flutter pub get`
- Restart Android Studio/VS Code

### Database errors?
- Verify migration ran successfully
- Check all tables exist in Supabase
- Verify RLS policies are enabled

### Authentication fails?
- Check email format is valid
- Password must be 6+ characters
- Check Supabase Auth is enabled

## 📚 Documentation Reference

- **Quick Start**: `QUICKSTART.md`
- **Full Setup**: `SETUP_GUIDE.md`
- **Features**: `APP_FEATURES.md`
- **Status**: `PROJECT_STATUS.md`

## ⏱️ Total Time Estimate

- Supabase Setup: 5 minutes
- Database Migration: 2 minutes
- Configuration: 1 minute
- Dependencies: 1 minute
- Run App: 1 minute
- **Total: ~10 minutes**

## 🎊 Ready to Go!

Once all items are checked, you have a fully working HEIC Converter app!

---

**Need Help?** Check the documentation files or Supabase dashboard logs.
