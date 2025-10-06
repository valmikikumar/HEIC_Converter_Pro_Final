class AppConstants {
  static const String appName = 'HEIC Converter Pro';
  static const String appVersion = '1.0.0';

  static const int freeUserConversionLimit = 50;
  static const int proUserConversionLimit = -1;

  static const String proMonthlyProductId = 'heic_pro_monthly';
  static const String proYearlyProductId = 'heic_pro_yearly';
  static const String proLifetimeProductId = 'heic_pro_lifetime';

  static const String androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910';

  static const List<String> supportedInputFormats = ['heic', 'heif'];
  static const List<String> supportedOutputFormats = ['jpg', 'png', 'pdf'];

  static const Map<String, int> qualityPresets = {
    'high': 95,
    'medium': 85,
    'low': 70,
  };
}
