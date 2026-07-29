import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/character_entity.dart';
import '../widgets/character_header.dart';
import '../widgets/characters_error_state.dart';
import '../widgets/detail_info_tile.dart';
import '../widgets/episodes_section.dart';

/// Shows full details for one character. Receives the already-fetched
/// [CharacterEntity] via the route's `extra` (see app_router.dart) rather
/// than re-fetching from the API — see Phase 4A's architecture note for
/// why that's the right call here.
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

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            children: [
              CharacterHeader(character: entity),
              SizedBox(height: 24.h),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 2.6,
                children: [
                  DetailInfoTile(icon: Icons.pets_rounded, label: 'Species', value: entity.species),
                  DetailInfoTile(icon: Icons.category_rounded, label: 'Type', value: entity.type),
                  DetailInfoTile(icon: Icons.wc_rounded, label: 'Gender', value: entity.gender),
                  DetailInfoTile(icon: Icons.public_rounded, label: 'Origin', value: entity.origin.name),
                ],
              ),
              SizedBox(height: 12.h),
              DetailInfoTile(
                icon: Icons.location_on_rounded,
                label: 'Last known location',
                value: entity.location.name,
              ),
              SizedBox(height: 12.h),
              EpisodesSection(episodeUrls: entity.episode),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}