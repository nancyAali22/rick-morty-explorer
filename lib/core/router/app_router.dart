import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

/// go_router configuration. Character list/details routes are wired here
/// with placeholders now; Phase 2/3 will replace them with real pages
/// once the characters feature's presentation layer exists.
class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.characters,
        name: 'characters',
        builder: (context, state) => const _PlaceholderPage(title: 'Characters'),
      ),
      GoRoute(
        path: RouteNames.characterDetails,
        name: 'characterDetails',
        builder: (context, state) {
          final String id = state.pathParameters['id'] ?? '';
          return _PlaceholderPage(title: 'Character #$id');
        },
      ),
    ],
  );
}

/// Temporary page used only until the real feature pages are built.
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — coming in the next phase')),
    );
  }
}
