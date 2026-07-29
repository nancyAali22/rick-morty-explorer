import 'package:go_router/go_router.dart';

import '../../features/characters/domain/entities/character_entity.dart';
import '../../features/characters/presentation/pages/character_details_page.dart';
import '../../features/characters/presentation/pages/characters_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'route_names.dart';

/// go_router configuration. Both Characters list and Character details
/// are wired to their real pages now.
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
        builder: (context, state) => const CharactersPage(),
      ),
      GoRoute(
        path: RouteNames.characterDetails,
        name: 'characterDetails',
        builder: (context, state) {
          final character = state.extra as CharacterEntity?;
          return CharacterDetailsPage(character: character);
        },
      ),
    ],
  );
}
