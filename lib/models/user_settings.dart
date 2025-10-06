enum ThemeMode { light, dark, system }

class UserSettings {
  final String id;
  final String userId;
  final ThemeMode themeMode;
  final String defaultOutputFormat;
  final String qualityPreset;
  final bool autoDeleteAfterConversion;
  final bool showAds;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserSettings({
    required this.id,
    required this.userId,
    required this.themeMode,
    required this.defaultOutputFormat,
    required this.qualityPreset,
    required this.autoDeleteAfterConversion,
    required this.showAds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      themeMode: _parseThemeMode(json['theme_mode'] as String?),
      defaultOutputFormat: json['default_output_format'] as String? ?? 'jpg',
      qualityPreset: json['quality_preset'] as String? ?? 'high',
      autoDeleteAfterConversion: json['auto_delete_after_conversion'] as bool? ?? false,
      showAds: json['show_ads'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  static ThemeMode _parseThemeMode(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'theme_mode': themeMode.name,
      'default_output_format': defaultOutputFormat,
      'quality_preset': qualityPreset,
      'auto_delete_after_conversion': autoDeleteAfterConversion,
      'show_ads': showAds,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserSettings copyWith({
    ThemeMode? themeMode,
    String? defaultOutputFormat,
    String? qualityPreset,
    bool? autoDeleteAfterConversion,
    bool? showAds,
  }) {
    return UserSettings(
      id: id,
      userId: userId,
      themeMode: themeMode ?? this.themeMode,
      defaultOutputFormat: defaultOutputFormat ?? this.defaultOutputFormat,
      qualityPreset: qualityPreset ?? this.qualityPreset,
      autoDeleteAfterConversion: autoDeleteAfterConversion ?? this.autoDeleteAfterConversion,
      showAds: showAds ?? this.showAds,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
