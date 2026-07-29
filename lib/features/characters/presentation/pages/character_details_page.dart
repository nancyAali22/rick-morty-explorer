import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/character_entity.dart';
import '../widgets/character_header.dart';
import '../widgets/characters_error_state.dart';
import '../widgets/detail_info_tile.dart';
import '../widgets/episodes_section.dart';

/// Shows full details for one character. Receives the already-fetched
/// [CharacterEntity] via the route's `extra` (see app_router.dart) rather
/// than re-fetching from the API — see Phase 4A's architecture note for
/// why that's the right call here.
///
/// Background carries a subtle top-to-bottom gradient built from the
/// same themed background/surface tokens used everywhere else in the
/// app — deliberately low-contrast so it never competes with the hero
/// image or hurts text legibility. Content below the hero reveals with
/// a staggered fade/slide, timed to start right after [CharacterHeader]'s
/// own entrance animation.
class CharacterDetailsPage extends StatelessWidget {
  final CharacterEntity? character;

  const CharacterDetailsPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final entity = character;

    if (entity == null) {
      // Reached without list context (e.g. a raw deep link). Rather than
      // silently failing or adding a network fallback nothing else in
      // this app needs, we show a clear way back to the list.
      return Scaffold(
        appBar: AppBar(),
        body: CharactersErrorState(
          message: 'Open this character from the list to see its details.',
          onRetry: () => context.go(RouteNames.characters),
        ),
      );
    }

    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final List<Color> gradientColors = isDark
        ? [
            AppColors.darkBackground,
            AppColors.darkSurface.withValues(alpha: 0.5)
          ]
        : [
            AppColors.lightBackground,
            AppColors.lightSurface.withValues(alpha: 0.5)
          ];

    return Scaffold(
      appBar: AppBar(),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              children: [
                CharacterHeader(character: entity),
                SizedBox(height: 24.h),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: DetailInfoTile(
                          icon: Icons.pets_rounded,
                          label: 'Species',
                          value: entity.species,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: DetailInfoTile(
                          icon: Icons.category_rounded,
                          label: 'Type',
                          value: entity.type,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(
                        delay: 150.ms, duration: 300.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.12,
                      end: 0,
                      delay: 150.ms,
                      duration: 300.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: 12.h),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: DetailInfoTile(
                          icon: Icons.wc_rounded,
                          label: 'Gender',
                          value: entity.gender,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: DetailInfoTile(
                          icon: Icons.public_rounded,
                          label: 'Origin',
                          value: entity.origin.name,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(
                        delay: 200.ms, duration: 300.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.12,
                      end: 0,
                      delay: 200.ms,
                      duration: 300.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: 12.h),
                DetailInfoTile(
                  icon: Icons.location_on_rounded,
                  label: 'Last known location',
                  value: entity.location.name,
                )
                    .animate()
                    .fadeIn(
                        delay: 250.ms, duration: 300.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.12,
                      end: 0,
                      delay: 250.ms,
                      duration: 300.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: 12.h),
                EpisodesSection(episodeUrls: entity.episode)
                    .animate()
                    .fadeIn(
                        delay: 300.ms, duration: 300.ms, curve: Curves.easeOut)
                    .slideY(
                      begin: 0.12,
                      end: 0,
                      delay: 300.ms,
                      duration: 300.ms,
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
