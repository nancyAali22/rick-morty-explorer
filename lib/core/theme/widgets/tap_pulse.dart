import 'package:flutter/material.dart';

/// Wraps [child] with a quick, subtle scale-down/up "pulse" on tap — used
/// wherever a selection or action should feel tactile instead of an
/// instant color/state snap (filter chips today; reusable anywhere else
/// that wants the same premium micro-interaction).
///
/// Deliberately not an [InkWell]/ripple replacement, and not a
/// [GestureDetector]: it uses [Listener], which only *observes* pointer
/// events without consuming them — so [child] keeps whatever tap
/// handling it already has (e.g. [ChoiceChip.onSelected]) and this
/// purely layers a transform animation on top.
class TapPulse extends StatefulWidget {
  const TapPulse({super.key, required this.child, this.scale = 0.94});

  final Widget child;
  final double scale;

  @override
  State<TapPulse> createState() => _TapPulseState();
}

class _TapPulseState extends State<TapPulse> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}