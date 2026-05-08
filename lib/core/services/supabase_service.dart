import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/flavor_config.dart';


@lazySingleton
class SupabaseService {
  SupabaseService(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const String _keyAccessToken = 'supabase_access_token';
  static const String _keyRefreshToken = 'supabase_refresh_token';
  static const String _keyUserId = 'supabase_user_id';
  static const String _keyUserEmail = 'supabase_user_email';
  static const String _keyExpiresAt = 'supabase_expires_at';

  /// Supabase client instance — initialized once in main.dart.
  SupabaseClient get client => Supabase.instance.client;

  /// Sign up a new citizen with email and password.
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// Sign in with email and password.
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out — invalidates token on Supabase server.
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Send password reset email.
  Future<void> sendPasswordResetEmail({required String email}) async {
    await client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'etax://reset-password',
    );
  }

  /// Update password — used after reset link is clicked.
  Future<UserResponse> updatePassword({required String newPassword}) async {
    return client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  /// Save all session tokens to SecureStorage.
  /// Called after every successful login or register.
  /// We store both tokens 
  Future<void> saveSession(Session session) async {
    await Future.wait([
      _secureStorage.write(
        key: _keyAccessToken,
        value: session.accessToken,
      ),
      _secureStorage.write(
        key: _keyRefreshToken,
        value: session.refreshToken,
      ),
      _secureStorage.write(
        key: _keyUserId,
        value: session.user.id,
      ),
      _secureStorage.write(
        key: _keyUserEmail,
        value: session.user.email ?? '',
      ),
      _secureStorage.write(
        key: _keyExpiresAt,
        value: session.expiresAt?.toString() ?? '',
      ),
    ]);
  }

  /// Get the stored access token.
  /// Used by AuthInterceptor to attach Bearer token to Dio requests.
  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _keyAccessToken);
  }

  /// Get the stored refresh token.
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _keyRefreshToken);
  }

  /// Get the stored user ID (UUID string).
  Future<String?> getUserId() async {
    return _secureStorage.read(key: _keyUserId);
  }

  /// Get the stored user email.
  Future<String?> getUserEmail() async {
    return _secureStorage.read(key: _keyUserEmail);
  }

  /// Check if citizen is currently logged in.
  /// Checks both SecureStorage AND Supabase SDK session.
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    final hasLocalToken = token != null && token.isNotEmpty;
    final hasSupabaseSession = client.auth.currentSession != null;
    return hasLocalToken || hasSupabaseSession;
  }

  /// Clear all stored auth data on logout.
  Future<void> clearSession() async {
    await Future.wait([
      _secureStorage.delete(key: _keyAccessToken),
      _secureStorage.delete(key: _keyRefreshToken),
      _secureStorage.delete(key: _keyUserId),
      _secureStorage.delete(key: _keyUserEmail),
      _secureStorage.delete(key: _keyExpiresAt),
    ]);
  }

  /// Initialize Supabase — called once in main.dart before runApp.
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: FlavorConfig.supabaseUrl,
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),
    );
  }
}