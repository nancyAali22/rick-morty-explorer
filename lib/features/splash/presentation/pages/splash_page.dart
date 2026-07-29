import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/splash_logo_mark.dart';
import '../widgets/splash_wordmark.dart';

/// First screen shown on launch. Its only job is the animated brand
/// moment, then navigating on to [RouteNames.characters] — nothing else
/// lives here.
///
/// Why there's no DI initialization or connectivity check in this widget:
/// - DI is already `await`-ed inside `main()` *before* `runApp` is even
///   called (see main.dart). By the time this widget exists, every
///   dependency is already registered — redoing that here would just be
///   redundant, not "extra safe".
/// - A connectivity check was deliberately left out too. [CharactersCubit]
///   already turns "no internet" into a `NetworkFailure`, surfaced through
///   `CharactersErrorState` with a working Retry button, the moment it
///   tries to load. Re-checking connectivity here would duplicate logic
///   that already has exactly one correct home — and this screen would
///   just have to hand off to that same error UI anyway.
///
/// Why there's no theme-flash handling here either: [ThemeCubit]'s
/// initial state is already loaded from [ThemeModeStorage] *before*
/// `runApp` (see injection_container.dart), so `Theme.of(context)` below
/// is correct on this widget's very first frame — light on first-ever
/// launch, or whatever the user last saved on every launch after that.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) context.go(RouteNames.characters);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    // Mint <-> off-white/background pairing in both modes — ties into
    // `AppColors.statusAlive == accentMint` already used elsewhere in
    // the app for "alive / explore" meaning, which fits an explorer app
    // better than the brown/beige pairing would.
    final Color gradientStart =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color gradientEnd = isDark
        ? AppColors.accentMintDark.withValues(alpha: 0.35)
        : AppColors.accentMint.withValues(alpha: 0.35);
    final Color ringColor =
        isDark ? AppColors.primaryBrownOnDark : AppColors.primaryBrown;
    final Color accentColor =
        isDark ? AppColors.accentMintDark : AppColors.accentMintDeep;

    // Clamped against the shortest side (not `.w` from screenutil) so
    // the mark stays proportionate on tablets/foldables instead of
    // scaling up indefinitely with device width.
    final double shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final double logoSize = (shortestSide * 0.32).clamp(96.0, 180.0);

    return Scaffold(
      body: AnimatedGradientBackground(
        colorA: gradientStart,
        colorB: gradientEnd,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SplashLogoMark(
                    ringColor: ringColor,
                    accentColor: accentColor,
                    size: logoSize,
                  ),
                  SizedBox(height: 24.h),
                  SplashWordmark(
                    title: AppConstants.appName,
                    tagline: 'Explore the multiverse',
                    titleStyle:
                        theme.textTheme.titleLarge?.copyWith(fontSize: 20.sp),
                    taglineStyle: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
