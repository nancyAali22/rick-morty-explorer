import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/character_entity.dart';
import 'status_badge.dart';

/// A single character tile: avatar (with Hero tag for the details
/// transition), name, species and a status badge. Purely presentational —
/// it renders a [CharacterEntity], nothing else.
///
/// Carries a thin gold-family border ([AppColors.goldBorderFor]) for
/// premium detailing, and a capped, staggered fade/scale entrance driven
/// by [index] — [CharactersPage] keys the grid by the active search/
/// filter signature, so this entrance replays on genuine data changes
/// (first load, new search, new filters) without replaying on every
/// rebuild caused by scrolling/pagination.
class CharacterCard extends StatelessWidget {
  final CharacterEntity character;
  final VoidCallback? onTap;
  final int index;

  const CharacterCard({
    super.key,
    required this.character,
    this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color borderColor = AppColors.goldBorderFor(theme.brightness);
    final BorderRadius radius = BorderRadius.circular(20.r);

    final Widget card = Card(
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'character-avatar-${character.id}',
                    child: CachedNetworkImage(
                      imageUrl: character.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: theme.colorScheme.surface),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surface,
                        child: Icon(Icons.image_not_supported_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: StatusBadge(status: character.status, dense: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    character.species,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // Capped so a long grid doesn't end up with a multi-second wave —
    // only the first ~12 tiles actually stagger, the rest fade in
    // together right after them.
    final int cappedIndex = index.clamp(0, 12);
    final Duration delay = Duration(milliseconds: 35 * cappedIndex);

    return card
        .animate()
        .fadeIn(delay: delay, duration: 260.ms, curve: Curves.easeOut)
        .scale(
      delay: delay,
      begin: const Offset(0.92, 0.92),
      end: const Offset(1.0, 1.0),
      duration: 260.ms,
      curve: Curves.easeOutCubic,
    );
  }
}