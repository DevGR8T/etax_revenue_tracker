import 'package:injectable/injectable.dart';
import 'supabase_service.dart';

@lazySingleton
class AuthService {
  AuthService(this._supabaseService);

  final SupabaseService _supabaseService;

  Future<String?> getToken() => _supabaseService.getAccessToken();

  Future<bool> isLoggedIn() => _supabaseService.isLoggedIn();

  Future<void> clearAll() => _supabaseService.clearSession();
}