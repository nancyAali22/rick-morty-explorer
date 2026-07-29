import 'package:flutter/material.dart';

/// Full-bleed animated gradient behind the splash content.
///
/// Two phases run back to back:
/// 1. **Settle** (one-time, [_settleDuration]): the gradient stops relax
///    from a tighter, slightly off-center pair of alignments into their
///    resting top-left/bottom-right position — so the background itself
///    is part of the entrance sequence, not a static backdrop the logo
///    happens to sit on.
/// 2. **Drift** (looping, [_driftDuration]): once settled, the alignment
///    sways gently back and forth forever. Amplitude is deliberately
///    small (±0.08) — this is ambient texture, not a feature, so it
///    should never pull attention away from the logo/wordmark above it.
///
/// Colors are supplied by the caller ([SplashPage]), which resolves them
/// from [AppColors] for whichever theme is active — this widget has no
/// opinion on light vs dark, it only paints the two colors it's given.
class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    super.key,
    required this.colorA,
    required this.colorB,
    required this.child,
  });

  final Color colorA;
  final Color colorB;
  final Widget child;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with TickerProviderStateMixin {
  static const Duration _settleDuration = Duration(milliseconds: 1000);
  static const Duration _driftDuration = Duration(milliseconds: 5000);

  static const Alignment _restBegin = Alignment(-1.0, -1.0);
  static const Alignment _restEnd = Alignment(1.0, 1.0);

  late final AnimationController _settleController;
  late final AnimationController _driftController;
  late final Animation<Alignment> _settleBegin;
  late final Animation<Alignment> _settleEnd;

  @override
  void initState() {
    super.initState();

    _settleController =
        AnimationController(vsync: this, duration: _settleDuration);
    _driftController =
        AnimationController(vsync: this, duration: _driftDuration);

    _settleBegin = AlignmentTween(
      begin: const Alignment(-0.15, -0.5),
      end: _restBegin,
    ).animate(CurvedAnimation(parent: _settleController, curve: Curves.easeOutCubic));

    _settleEnd = AlignmentTween(
      begin: const Alignment(0.15, 0.5),
      end: _restEnd,
    ).animate(CurvedAnimation(parent: _settleController, curve: Curves.easeOutCubic));

    _settleController.forward().whenComplete(() {
      if (mounted) _driftController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _settleController.dispose();
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_settleController, _driftController]),
      builder: (context, child) {
        final double sway =
            Curves.easeInOut.transform(_driftController.value) * 0.08 - 0.04;

        final Alignment begin = _settleBegin.value + Alignment(sway, sway);
        final Alignment end = _settleEnd.value + Alignment(-sway, -sway);

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: [widget.colorA, widget.colorB],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}