import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/character_entity.dart';
import 'status_badge.dart';

/// The top hero section of the details screen: large avatar continuing
/// the Hero transition from [CharacterCard], the name, and the status.
///
/// Carries the same gold-family border as [CharacterCard]
/// ([AppColors.goldBorderFor]) but heavier (1.6 vs the card's 1), so the
/// hero reads as the visually "heaviest" element on the page. A subtle
/// gradient fades the bottom edge of the image into the page background
/// (the themed [Theme.scaffoldBackgroundColor], which already resolves to
/// the AppColors background token) so the avatar feels grounded in the
/// page rather than a pasted-on rectangle sitting on top of it.
///
/// Entrance: fades and scales in first — see [CharacterDetailsPage],
/// which staggers the info cards in right after this.
class CharacterHeader extends StatelessWidget {
  final CharacterEntity character;

  const CharacterHeader({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color borderColor = AppColors.goldBorderFor(theme.brightness);
    final BorderRadius radius = BorderRadius.circular(28.r);

    final Widget hero = Column(
      children: [
        Hero(
          tag: 'character-avatar-${character.id}',
          child: Container(
            width: 180.w,
            height: 180.w,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: borderColor, width: 1.6),
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: character.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: theme.colorScheme.surface),
                    errorWidget: (context, url, error) => Container(
                      color: theme.colorScheme.surface,
                      child: Icon(Icons.image_not_supported_rounded, size: 40.sp),
                    ),
                  ),
                  // Fades the bottom edge of the image into the page
                  // background so it feels integrated with the rest of
                  // the screen instead of floating on top of it.
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
                            theme.scaffoldBackgroundColor.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          character.name,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 24.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.h),
        StatusBadge(status: character.status),
      ],
    );

    return hero
        .animate()
        .fadeIn(duration: 300.ms, curve: Curves.easeOut)
        .scale(
      begin: const Offset(0.94, 0.94),
      end: const Offset(1.0, 1.0),
      duration: 300.ms,
      curve: Curves.easeOutCubic,
    );
  }
}