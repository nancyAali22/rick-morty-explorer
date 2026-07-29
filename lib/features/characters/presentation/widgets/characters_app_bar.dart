import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/widgets/theme_toggle_button.dart';

/// The Characters screen's app bar: the "Characters" title with slightly
/// heavier, more deliberate typography, and the theme toggle action.
///
/// Extracted out of [CharactersPage] purely to keep that file focused on
/// orchestration — this widget owns no state and reads nothing beyond
/// [Theme.of(context)].
class CharactersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CharactersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppBar(
      title: Text(
        'Characters',
        style: theme.textTheme.titleLarge?.copyWith(
          fontSize: 22.sp,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        const ThemeToggleButton(),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
