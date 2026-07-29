import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholders shaped exactly like [CharacterCard], shown while
/// the first page is loading — avoids a jarring layout shift once real
/// content arrives.
class CharactersSkeletonGrid extends StatelessWidget {
  final int crossAxisCount;

  const CharactersSkeletonGrid({super.key, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surface,
      highlightColor: theme.brightness == Brightness.light
          ? const Color(0xFFFFFFFF)
          : theme.colorScheme.surfaceContainerHighest,
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: crossAxisCount * 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20.r),
            ),
          );
        },
      ),
    );
  }
}