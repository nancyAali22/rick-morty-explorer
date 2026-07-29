import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/character_entity.dart';
import 'status_badge.dart';

/// The top hero section of the details screen: large avatar continuing
/// the Hero transition from [CharacterCard], the name, and the status.
class CharacterHeader extends StatelessWidget {
  final CharacterEntity character;

  const CharacterHeader({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Hero(
          tag: 'character-avatar-${character.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: CachedNetworkImage(
              imageUrl: character.image,
              width: 180.w,
              height: 180.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: theme.colorScheme.surface),
              errorWidget: (context, url, error) => Container(
                color: theme.colorScheme.surface,
                child: Icon(Icons.image_not_supported_rounded, size: 40.sp),
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
  }
}