# 🎯 Quick Reference Card

## 🚀 Get Started in 3 Steps

1. **Setup Supabase** → Create project & run migration
2. **Configure App** → Update `lib/config/supabase_config.dart`
3. **Run App** → `flutter run`

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| `START_HERE.md` | Project overview |
| `QUICKSTART.md` | 5-minute setup |
| `CHECKLIST.md` | Setup checklist |
| `supabase_migration.sql` | Database schema |
| `lib/config/supabase_config.dart` | Your credentials go here |

---

## 💻 Essential Commands

```bash
# Install dependencies
flutter pub get

# Run app (development)
flutter run

# Build APK (release)
flutter build apk --release

# Clean build
flutter clean

# Check Flutter version
flutter --version
```

---

## 🗄️ Database Tables

| Table | What It Stores |
|-------|----------------|
| `profiles` | User accounts, stats, Pro status |
| `conversions` | File conversion history |
| `subscriptions` | Pro membership data |
| `user_settings` | Theme, format, quality preferences |

---

## 📱 App Screens

1. **Splash** → Auto-navigation
2. **Login** → Email/password auth
3. **Signup** → New user registration
4. **Home** → Dashboard with 3 tabs
5. **Conversion** → File processing
6. **Profile** → User info & upgrade
7. **Settings** → App preferences

---

## 🔐 Supabase Setup

1. Go to [supabase.com](https://supabase.com)
2. Create project (2 min wait)
3. Go to SQL Editor
4. Paste `supabase_migration.sql` content
5. Click "Run"
6. Go to Settings → API
7. Copy Project URL & Anon Key
8. Update `lib/config/supabase_config.dart`

---

## ⚙️ Configuration Location

Update your credentials here:
```
lib/config/supabase_config.dart
```

Replace:
- `supabaseUrl` with your project URL
- `supabaseAnonKey` with your anon key

---

## 🎨 Customization Quick Tips

### Change Colors
Edit `lib/main.dart` → Look for `ColorScheme.fromSeed`

### Change Limits
Edit `lib/utils/app_constants.dart` → Update conversion limits

### Change App Name
Edit `pubspec.yaml` → Update `name` field

### Change Package ID
Edit `android/app/build.gradle` → Update `applicationId`

---

## 📊 Project Stats

- **Dart Files**: 15
- **Screens**: 8
- **Models**: 3
- **Services**: 2
- **Database Tables**: 4
- **Lines of Code**: 2000+

---

## ✅ What Works

- ✅ Email/Password authentication
- ✅ User signup with auto profile
- ✅ Secure login/logout
- ✅ HEIC to JPG/PNG/PDF conversion
- ✅ Batch file processing
- ✅ Usage tracking (50 free conversions)
- ✅ User profiles & statistics
- ✅ Settings & preferences
- ✅ Dark/light themes
- ✅ Database with Row Level Security

---

## 🔄 Typical Workflow

```
User Signs Up
    ↓
Profile Auto-Created in Database
    ↓
User Selects HEIC Files
    ↓
Chooses Output Format (JPG/PNG/PDF)
    ↓
Files Convert with Progress Bar
    ↓
Results Displayed
    ↓
User Saves/Shares Files
    ↓
Conversion Saved to Database
    ↓
Usage Count Incremented
```

---

## 🆘 Common Issues

### Can't connect to Supabase?
→ Check credentials in `supabase_config.dart`

### Database errors?
→ Verify migration ran successfully in SQL Editor

### Build errors?
→ Run `flutter clean` then `flutter pub get`

### Authentication fails?
→ Check email format and password length (6+ chars)

---

## 📞 Support Resources

1. **Documentation**
   - START_HERE.md
   - QUICKSTART.md
   - SETUP_GUIDE.md

2. **Supabase Help**
   - Dashboard → Logs
   - Documentation: docs.supabase.com

3. **Flutter Help**
   - flutter.dev/docs
   - Run: `flutter doctor`

---

## 🎯 Quick Test Checklist

- [ ] App launches
- [ ] Can signup new user
- [ ] Can login
- [ ] Can select files
- [ ] Conversion works
- [ ] Results display
- [ ] Can save/share
- [ ] Profile shows stats
- [ ] Settings work
- [ ] Can logout

---

## 💎 Free vs Pro

| Feature | Free | Pro |
|---------|------|-----|
| Conversions | 50 | Unlimited |
| Formats | All | All |
| Quality | All | All |
| Ads | Yes | No |
| Support | Basic | Priority |

---

## 🏗️ Build Commands

```bash
# Development
flutter run

# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release

# iOS (requires Mac)
flutter build ios --release
```

---

## 📦 Output Locations

**Android APK:**
`build/app/outputs/flutter-apk/app-release.apk`

**App Bundle:**
`build/app/outputs/bundle/release/app-release.aab`

---

## ⏱️ Time Estimates

- Supabase Setup: 5 min
- Database Migration: 2 min
- App Configuration: 1 min
- First Run: 2 min
- **Total: ~10 minutes**

---

## 🎊 Success Indicators

✅ App runs without errors
✅ Can create new account
✅ Data appears in Supabase dashboard
✅ Conversion works end-to-end
✅ Settings persist
✅ APK builds successfully

---

**Ready? Start with START_HERE.md!** 🚀
