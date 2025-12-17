import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _selectedGenresKey = 'selected_genres';
  static const String _hasCompletedOnboardingKey = 'has_completed_onboarding';
  static const String _userNameKey = 'user_name';
  static const String _userSurnameKey = 'user_surname';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';

  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ========== GENRES ==========

  Future<bool> saveSelectedGenres(List<String> genres) async {
    await init();
    return await _prefs!.setStringList(_selectedGenresKey, genres);
  }

  Future<List<String>> getSelectedGenres() async {
    await init();
    return _prefs!.getStringList(_selectedGenresKey) ?? [];
  }

  Future<bool> clearSelectedGenres() async {
    await init();
    return await _prefs!.remove(_selectedGenresKey);
  }

  // ========== ONBOARDING ==========

  Future<bool> setOnboardingCompleted(bool completed) async {
    await init();
    return await _prefs!.setBool(_hasCompletedOnboardingKey, completed);
  }

  Future<bool> hasCompletedOnboarding() async {
    await init();
    return _prefs!.getBool(_hasCompletedOnboardingKey) ?? false;
  }

  // ========== USER DATA ==========

  Future<void> saveUserData({
    required String name,
    required String surname,
    required String email,
    required String phone,
  }) async {
    await init();
    await _prefs!.setString(_userNameKey, name);
    await _prefs!.setString(_userSurnameKey, surname);
    await _prefs!.setString(_userEmailKey, email);
    await _prefs!.setString(_userPhoneKey, phone);
  }

  Future<String?> getUserName() async {
    await init();
    return _prefs!.getString(_userNameKey);
  }

  Future<String?> getUserSurname() async {
    await init();
    return _prefs!.getString(_userSurnameKey);
  }

  Future<String?> getUserEmail() async {
    await init();
    return _prefs!.getString(_userEmailKey);
  }

  Future<String?> getUserPhone() async {
    await init();
    return _prefs!.getString(_userPhoneKey);
  }

  // ========== CLEAR ALL ==========

  Future<bool> clearAll() async {
    await init();
    return await _prefs!.clear();
  }
}
