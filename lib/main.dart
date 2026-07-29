import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const RickMortyApp());
}

class RickMortyApp extends StatelessWidget {
  const RickMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provided once, above MaterialApp.router, so every route in the app
    // shares this one ThemeCubit instance without re-providing it per page.
    return BlocProvider.value(
      value: di.sl<ThemeCubit>(),
      child: ScreenUtilInit(
        designSize: Size(AppConstants.designWidth, AppConstants.designHeight),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final ThemeData activeTheme =
                  themeMode == ThemeMode.dark ? AppTheme.dark : AppTheme.light;

              return MaterialApp.router(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                // No `darkTheme` / `themeMode` here on purpose — the app
                // is fully manual now, so `theme` alone always resolves
                // to exactly the mode ThemeCubit holds. ThemeMode.system
                // is never consulted.
                theme: activeTheme,
                routerConfig: AppRouter.router,
                // Wrapping the Navigator in AnimatedTheme is what makes
                // every screen's colors cross-fade on toggle instead of
                // snapping instantly — this covers the whole app because
                // every route sits below this builder.
                builder: (context, child) {
                  return AnimatedTheme(
                    data: activeTheme,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
