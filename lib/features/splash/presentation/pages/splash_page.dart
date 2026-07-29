import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';

/// First screen shown on launch. Its only job is the brief animated
/// brand moment, then navigating on to [RouteNames.characters] — nothing
/// else lives here.
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
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Future.delayed(AppConstants.splashDuration, () {
      if (mounted) context.go(RouteNames.characters);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.travel_explore_rounded,
                    size: 56.sp,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Explore the multiverse',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}