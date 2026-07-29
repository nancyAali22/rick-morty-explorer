/// App-wide non-API constants: strings, durations, shared keys.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Rick & Morty Explorer';

  static const Duration splashDuration = Duration(milliseconds: 1600);
  static const Duration searchDebounce = Duration(milliseconds: 450);

  // Design size used by flutter_screenutil as the reference (iPhone-like).
  static const double designWidth = 390;
  static const double designHeight = 844;
}
