import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App name + tagline, revealed with a short staggered slide/fade after
/// [SplashLogoMark] has already appeared — this is what turns "logo pops
/// in" into a deliberate staged sequence instead of everything arriving
/// on screen at once.
class SplashWordmark extends StatelessWidget {
  const SplashWordmark({
    super.key,
    required this.title,
    required this.tagline,
    required this.titleStyle,
    required this.taglineStyle,
  });

  final String title;
  final String tagline;
  final TextStyle? titleStyle;
  final TextStyle? taglineStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: titleStyle, textAlign: TextAlign.center)
            .animate(delay: 500.ms)
            .fadeIn(duration: 450.ms, curve: Curves.easeOut)
            .slideY(
          begin: 0.25,
          end: 0,
          duration: 450.ms,
          curve: Curves.easeOutCubic,
        ),
        SizedBox(height: 8.h),
        Text(tagline, style: taglineStyle, textAlign: TextAlign.center)
            .animate(delay: 700.ms)
            .fadeIn(duration: 450.ms, curve: Curves.easeOut)
            .slideY(
          begin: 0.25,
          end: 0,
          duration: 450.ms,
          curve: Curves.easeOutCubic,
        ),
      ],
    );
  }
}