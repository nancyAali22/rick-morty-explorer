import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstraction over SharedPreferences so [ThemeCubit] depends on an
/// interface, not a concrete package (testable + swappable) — same
/// pattern as NetworkInfo/NetworkInfoImpl.
abstract class ThemeModeStorage {
  /// Returns the last saved [ThemeMode]. Falls back to [ThemeMode.light]
  /// when nothing has been saved yet (first launch) or the stored value
  /// is unrecognized — the app must never fall back to ThemeMode.system.
  Future<ThemeMode> loadThemeMode();

  Future<void> saveThemeMode(ThemeMode mode);
}

class ThemeModeStorageImpl implements ThemeModeStorage {
  static const String _themeModeKey = 'theme_mode';
  static const String _darkValue = 'dark';
  static const String _lightValue = 'light';

  final SharedPreferences _preferences;

  ThemeModeStorageImpl(this._preferences);

  @override
  Future<ThemeMode> loadThemeMode() async {
    final String? stored = _preferences.getString(_themeModeKey);
    return stored == _darkValue ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Future<void> saveThemeMode(ThemeMode mode) {
    final String value = mode == ThemeMode.dark ? _darkValue : _lightValue;
    return _preferences.setString(_themeModeKey, value);
  }
}