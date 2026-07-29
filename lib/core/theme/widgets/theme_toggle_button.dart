import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/theme_cubit.dart';

/// AppBar action that switches between light and dark mode.
///
/// Icon shown reflects the mode you'd switch *to*, not the current one:
/// light mode shows a moon (tap for dark), dark mode shows a sun (tap
/// for light) — matching the spec exactly.
///
/// Sits on a small tonal circle (theme.colorScheme.primary at low alpha)
/// so it reads as a deliberate control rather than a bare icon floating
/// in the app bar — and the circle's own tint animates too, so switching
/// modes feels like one coordinated transition, not just an icon swap.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final bool isDark = themeMode == ThemeMode.dark;
        final ThemeData theme = Theme.of(context);

        return Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary
                  .withValues(alpha: isDark ? 0.18 : 0.08),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => RotationTransition(
                  turns:
                      Tween<double>(begin: 0.72, end: 1.0).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey<bool>(isDark),
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
