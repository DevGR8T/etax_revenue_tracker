import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';

/// Handles local session storage operations.
/// All writes go to Flutter Secure Storage via SupabaseService.
abstract class AuthLocalDataSource {
  Future<String?> getAccessToken();
  Future<String?> getUserId();
  Future<bool> isLoggedIn();
  Future<void> clearAuth();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._supabaseService);

  final SupabaseService _supabaseService;

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _supabaseService.getAccessToken();
    } catch (_) {
      throw const CacheException(message: 'Failed to read access token');
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      return await _supabaseService.getUserId();
    } catch (_) {
      throw const CacheException(message: 'Failed to read user ID');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await _supabaseService.isLoggedIn();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> clearAuth() async {
    try {
      await _supabaseService.clearSession();
    } catch (_) {
      throw const CacheException(message: 'Failed to clear auth data');
    }
  }
}