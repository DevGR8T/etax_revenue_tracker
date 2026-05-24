import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';

/// Reads non-sensitive profile data from SharedPreferences.
/// State of residence saved during registration.
///
/// SharedPreferences is appropriate here — not sensitive data.
/// Tokens and auth data still use flutter_secure_storage via SupabaseService.
abstract class ProfileLocalDataSource {
  Future<String?> getStateOfResidence();
  Future<void> saveStateOfResidence(String state);
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String _keyState = 'state_of_residence';

  @override
  Future<String?> getStateOfResidence() async {
    try {
      return _prefs.getString(_keyState);
    } catch (_) {
      throw const CacheException(message: 'Could not read state of residence');
    }
  }

  @override
  Future<void> saveStateOfResidence(String state) async {
    try {
      await _prefs.setString(_keyState, state);
    } catch (_) {
      throw const CacheException(message: 'Could not save state of residence');
    }
  }
}