import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme_mode_storage.dart';

/// Single source of truth for the app's ThemeMode. Only ever holds
/// [ThemeMode.light] or [ThemeMode.dark] — the app never follows
/// [ThemeMode.system].
///
/// The initial state is passed in already-loaded (see
/// injection_container.dart), so there's no async gap between app start
/// and the correct theme being applied — no light-mode flash before a
/// saved dark preference kicks in.
class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeModeStorage _storage;

  ThemeCubit(this._storage, ThemeMode initialMode) : super(initialMode);

  void toggleTheme() {
    final ThemeMode next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(next);
    _storage.saveThemeMode(next);
  }
}