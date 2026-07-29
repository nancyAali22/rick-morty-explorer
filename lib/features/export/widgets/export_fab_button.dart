import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../presentation/cubit/export_cubit.dart';
import '../presentation/cubit/export_state.dart';

/// The Characters screen's export action — a dedicated widget (not
/// inline in `CharactersPage`) so its color pairing/shape/animation can
/// be reasoned about and adjusted in one place.
///
/// Fill is `theme.colorScheme.primary` (the brand espresso-brown) with
/// `onPrimary` icon/label — not the mint accent used elsewhere on this
/// screen. Mint already means "info/alive/selected" here (status badges,
/// selected filter chips); reusing it for the export action would blur
/// that meaning and is what made the old button feel arbitrary rather
/// than intentional. Brown + a thin gold trim (matching the card/search
/// bar border family) instead reads as a distinct "action" color that
/// still traces back to existing `AppTheme`/`AppColors` tokens, and
/// primary/onPrimary is already the pairing `AppTheme` designed for
/// contrast — so this fixes the contrast issue and the "doesn't feel
/// intentional" issue at once.
class ExportFabButton extends StatefulWidget {
  const ExportFabButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<ExportFabButton> createState() => _ExportFabButtonState();
}

class _ExportFabButtonState extends State<ExportFabButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color goldTrim = AppColors.goldBorderFor(theme.brightness);

    return BlocBuilder<ExportCubit, ExportState>(
      builder: (context, exportState) {
        final bool isExporting = exportState.status == ExportStatus.exporting;

        return Listener(
          onPointerDown: (_) => _setPressed(true),
          onPointerUp: (_) => _setPressed(false),
          onPointerCancel: (_) => _setPressed(false),
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: FloatingActionButton.extended(
              onPressed: isExporting ? null : widget.onPressed,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 3,
              highlightElevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.r),
                side: BorderSide(
                    color: goldTrim.withValues(alpha: 0.6), width: 1),
              ),
              icon: isExporting
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.ios_share_rounded),
              label: Text(
                isExporting ? 'Exporting…' : 'Export',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, letterSpacing: 0.2),
              ),
            ),
          ),
        );
      },
    );
  }
}
