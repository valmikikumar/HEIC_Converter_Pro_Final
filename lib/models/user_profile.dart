class UserProfile {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final bool isPro;
  final int conversionCount;
  final int maxConversions;
  final DateTime? proExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    required this.isPro,
    required this.conversionCount,
    required this.maxConversions,
    this.proExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      isPro: json['is_pro'] as bool? ?? false,
      conversionCount: json['conversion_count'] as int? ?? 0,
      maxConversions: json['max_conversions'] as int? ?? 50,
      proExpiresAt: json['pro_expires_at'] != null
          ? DateTime.parse(json['pro_expires_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'is_pro': isPro,
      'conversion_count': conversionCount,
      'max_conversions': maxConversions,
      'pro_expires_at': proExpiresAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? phoneNumber,
    bool? isPro,
    int? conversionCount,
    int? maxConversions,
    DateTime? proExpiresAt,
  }) {
    return UserProfile(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPro: isPro ?? this.isPro,
      conversionCount: conversionCount ?? this.conversionCount,
      maxConversions: maxConversions ?? this.maxConversions,
      proExpiresAt: proExpiresAt ?? this.proExpiresAt,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  bool get canConvert =>
      isPro || conversionCount < maxConversions;

  int get remainingConversions =>
      isPro ? -1 : maxConversions - conversionCount;
}
