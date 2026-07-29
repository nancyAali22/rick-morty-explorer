import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// Maps a raw API status string to its brand color. Shared by
/// [StatusBadge] and anything else that needs the same color (e.g. a
/// small dot indicator), so the mapping exists in exactly one place.
Color statusColorFor(String status) {
  switch (status.toLowerCase()) {
    case 'alive':
      return AppColors.statusAlive;
    case 'dead':
      return AppColors.statusDead;
    default:
      return AppColors.statusUnknown;
  }
}

/// A small pill badge showing a character's status with its semantic
/// color. Used on both the list card and the details screen so the
/// status treatment never has to be duplicated.
class StatusBadge extends StatelessWidget {
  final String status;
  final bool dense;

  const StatusBadge({super.key, required this.status, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final color = statusColorFor(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8.w : 12.w,
        vertical: dense ? 4.h : 6.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            status,
            style: TextStyle(
              fontSize: dense ? 10.sp : 12.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}