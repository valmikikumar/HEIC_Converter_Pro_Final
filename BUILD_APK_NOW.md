# 🚀 Build Your APK in 5 Minutes

## Quick Build Steps

### Step 1: Install Flutter (if not installed)
```bash
# Download Flutter SDK from:
https://docs.flutter.dev/get-started/install

# Or use FVM (Flutter Version Manager)
```

### Step 2: Setup Supabase (2 minutes)

1. Go to [supabase.com](https://supabase.com)
2. Click "Start your project"
3. Create new project (wait 2 min for setup)
4. Go to **Project Settings → API**
5. Copy your:
   - Project URL
   - Anon (public) key

### Step 3: Configure App (30 seconds)

Open `lib/config/supabase_config.dart` and replace:

```dart
static const String supabaseUrl = 'YOUR_URL_HERE';
static const String supabaseAnonKey = 'YOUR_KEY_HERE';
```

### Step 4: Setup Database (1 minute)

1. In Supabase dashboard, go to **SQL Editor**
2. Click "New query"
3. Open `supabase_migration.sql` file
4. Copy ALL contents
5. Paste in SQL Editor
6. Click **"Run"**
7. You should see "Success. No rows returned"

### Step 5: Build APK (2 minutes)

```bash
# Navigate to project folder
cd heic_converter_pro

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release
```

### Step 6: Find Your APK

Your APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

Install it on your Android device!

---

## 🎯 Even Faster: Online Build Services

### Option A: GitHub Actions (Free)

1. Create GitHub account
2. Upload this project to GitHub
3. Enable GitHub Actions
4. It will auto-build APK
5. Download from Actions artifacts

### Option B: Codemagic (Free tier available)

1. Go to [codemagic.io](https://codemagic.io)
2. Connect your repository
3. Configure build settings
4. Build APK in the cloud

### Option C: AppCircle (Free tier)

1. Go to [appcircle.io](https://appcircle.io)
2. Upload project
3. Auto-build APK

---

## ⚡ Super Quick: Use Android Studio

1. Open Android Studio
2. Open this project
3. Click "Build" → "Build Bundle(s) / APK(s)" → "Build APK(s)"
4. Wait 2-3 minutes
5. APK ready!

---

## 📱 Test Without Building

Run directly on emulator/device:

```bash
flutter run
```

This is faster for testing!

---

## 🆘 Don't Have Flutter?

### Install Flutter (Windows)
```powershell
# Download from:
https://docs.flutter.dev/get-started/install/windows
```

### Install Flutter (Mac)
```bash
brew install flutter
```

### Install Flutter (Linux)
```bash
sudo snap install flutter --classic
```

---

## 🎊 Your APK Will Have

✅ Working authentication (once Supabase is configured)
✅ Database connectivity
✅ All 8 screens
✅ File conversion
✅ User profiles
✅ Settings
✅ Professional UI

---

## 💡 Pro Tips

1. **Use an emulator** for fastest testing
2. **Cloud build** if you don't want to install Flutter
3. **GitHub Actions** for automated builds
4. The app **REQUIRES** Supabase setup to work

---

## 📞 Need the Fastest Path?

**Absolute fastest (5 minutes total):**

1. Install Flutter: 1 minute
2. Setup Supabase: 2 minutes
3. Configure app: 30 seconds
4. Run `flutter build apk --release`: 2 minutes
5. Done! Install APK

---

## 🚀 Start Building Now!

```bash
# Quick commands
flutter pub get
flutter build apk --release

# Your APK:
# build/app/outputs/flutter-apk/app-release.apk
```

**The app code is 100% complete - you just need to build it!**
