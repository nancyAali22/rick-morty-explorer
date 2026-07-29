import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Typography scale for the whole app. Sizes use .sp so they scale
/// correctly across phones and tablets via flutter_screenutil.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle displayLarge(Color color) => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle titleMedium(Color color) => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle bodyMedium(Color color) => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySmall(Color color) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle labelBold(Color color) => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: color,
      );
}
