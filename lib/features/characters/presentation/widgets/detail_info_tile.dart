import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// A single labeled fact row (icon + label + value), reused for every
/// attribute shown on the character details screen.
///
/// Carries the same gold-family border as [CharacterHeader]
/// ([AppColors.goldBorderFor]), but at low alpha and width 1 —
/// deliberately quieter than the hero image's opaque 1.6 border, so the
/// hero stays the visually heaviest element on the page and this grid of
/// tiles reads as lighter supporting detail.
class DetailInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color borderColor = AppColors.goldBorderFor(theme.brightness);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 18.sp, color: theme.colorScheme.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11.sp)),
                SizedBox(height: 2.h),
                Text(
                  value.isEmpty ? 'unknown' : value,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 14.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}