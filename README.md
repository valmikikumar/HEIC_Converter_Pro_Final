# 📱 HEIC Converter Pro

Professional HEIC to JPG/PNG/PDF conversion app with batch processing, Supabase authentication, and premium features.

## 🚀 Features

### ✅ Core Features
- **HEIC Conversion** - Convert HEIC/HEIF to JPG, PNG, PDF
- **Batch Processing** - Convert multiple files at once
- **High Quality** - Maintain original image quality
- **EXIF Preservation** - Keep metadata intact

### ✅ Free vs Pro
- **Free Users**: 50 conversions limit, ads
- **Pro Users**: Unlimited conversions, no ads, premium tools

### ✅ Authentication
- **Email/Password** login with Supabase
- **Secure authentication** with Row Level Security
- **User profiles** with automatic creation
- **Cloud data sync** across devices

### ✅ UI/UX
- **Material 3** design system
- **Dark/Light** mode support
- **Smooth animations** and transitions
- **Responsive** layout for all devices

## 🛠️ Tech Stack

- **Flutter** 3.16.0+
- **Supabase** (Auth, Database, Storage)
- **PostgreSQL** database with RLS
- **Riverpod** state management
- **Material 3** UI components
- **GoRouter** navigation

## 📱 Screenshots

- Splash Screen with gradient branding
- Home screen with file upload
- Conversion progress with real-time updates
- Results screen with preview and sharing
- Profile screen with Pro upgrade options
- Settings screen with theme preferences

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.16.0+
- Android Studio or Xcode
- Supabase account

### Quick Setup
1. Clone the repository
2. Run `flutter pub get`
3. Set up Supabase (see SETUP_GUIDE.md)
4. Update configuration in `lib/config/supabase_config.dart`
5. Run `flutter run`

### Build APK
```bash
flutter build apk --release
```

### Full Documentation
See **SETUP_GUIDE.md** for complete setup instructions.

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/                  # All app screens
│   ├── auth/                # Authentication screens
│   ├── home_screen.dart     # Main home screen
│   ├── conversion_*.dart    # Conversion screens
│   └── ...
├── services/                 # Business logic
├── models/                   # Data models
├── widgets/                  # Reusable UI components
└── utils/                    # Utilities and constants
```

## 🔧 Configuration

### Supabase Setup
1. Create Supabase project
2. Run database migration from `supabase_migration.sql`
3. Update credentials in `lib/config/supabase_config.dart`
4. Enable email authentication in Supabase dashboard

### Optional: Monetization
1. Set up AdMob account
2. Update Ad Unit IDs in `lib/utils/app_constants.dart`
3. Configure Google Play Billing product IDs

## 📱 Build & Deploy

This project automatically builds APK using GitHub Actions:

1. Push code to main branch
2. GitHub Actions builds APK automatically
3. Download APK from Actions artifacts
4. Or download from Releases section

## 🎯 Features in Detail

### Conversion Engine
- Support for HEIC/HEIF formats
- Output to JPG, PNG, PDF
- Batch processing with progress tracking
- Quality and size optimization

### User Management
- Supabase Authentication
- User profiles and settings
- Pro subscription management
- Cross-device synchronization
- Secure data with Row Level Security

### Monetization
- AdMob banner and interstitial ads
- Google Play Billing integration
- Free vs Pro feature differentiation
- Subscription management

## 🚀 Production Ready

This app is production-ready with:
- ✅ Complete feature implementation
- ✅ Professional UI/UX design
- ✅ Supabase integration with secure database
- ✅ Row Level Security policies
- ✅ Monetization setup ready
- ✅ Error handling
- ✅ Performance optimization

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📞 Support

For support, email support@heicconverterpro.com

---

**Ready to convert HEIC files like a pro! 🚀**