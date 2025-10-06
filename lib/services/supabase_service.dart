import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/user_profile.dart';
import '../models/conversion.dart';
import '../models/user_settings.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  Future<UserProfile?> getProfile(String userId) async {
    final response = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  Future<UserProfile> createProfile(UserProfile profile) async {
    final response = await client
        .from('profiles')
        .insert(profile.toJson())
        .select()
        .single();

    return UserProfile.fromJson(response);
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    final response = await client
        .from('profiles')
        .update(profile.toJson())
        .eq('id', profile.id)
        .select()
        .single();

    return UserProfile.fromJson(response);
  }

  Future<List<Conversion>> getConversions(String userId) async {
    final response = await client
        .from('conversions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => Conversion.fromJson(json))
        .toList();
  }

  Future<Conversion> createConversion(Conversion conversion) async {
    final response = await client
        .from('conversions')
        .insert(conversion.toJson())
        .select()
        .single();

    return Conversion.fromJson(response);
  }

  Future<Conversion> updateConversion(Conversion conversion) async {
    final response = await client
        .from('conversions')
        .update(conversion.toJson())
        .eq('id', conversion.id)
        .select()
        .single();

    return Conversion.fromJson(response);
  }

  Future<void> deleteConversion(String conversionId) async {
    await client.from('conversions').delete().eq('id', conversionId);
  }

  Future<UserSettings?> getSettings(String userId) async {
    final response = await client
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserSettings.fromJson(response);
  }

  Future<UserSettings> createSettings(UserSettings settings) async {
    final response = await client
        .from('user_settings')
        .insert(settings.toJson())
        .select()
        .single();

    return UserSettings.fromJson(response);
  }

  Future<UserSettings> updateSettings(UserSettings settings) async {
    final response = await client
        .from('user_settings')
        .update(settings.toJson())
        .eq('user_id', settings.userId)
        .select()
        .single();

    return UserSettings.fromJson(response);
  }

  Future<void> incrementConversionCount(String userId) async {
    await client.rpc('increment_conversion_count', params: {'user_id': userId});
  }

  Future<String> uploadFile(String path, List<int> bytes) async {
    final filename = path.split('/').last;
    final storagePath = 'conversions/${currentUser!.id}/$filename';

    await client.storage.from('heic-files').uploadBinary(
          storagePath,
          bytes,
        );

    return storagePath;
  }

  Future<List<int>> downloadFile(String path) async {
    return await client.storage.from('heic-files').download(path);
  }

  Future<void> deleteFile(String path) async {
    await client.storage.from('heic-files').remove([path]);
  }

  String getPublicUrl(String path) {
    return client.storage.from('heic-files').getPublicUrl(path);
  }
}
