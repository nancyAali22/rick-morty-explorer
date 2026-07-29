import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/widgets/tap_pulse.dart';

/// The values a filter sheet session produced, handed back to whoever
/// opened it — keeps the sheet decoupled from the Cubit (it doesn't
/// call the Cubit itself, the caller decides what to do with the result).
class CharacterFilterResult {
  final String? status;
  final String? species;
  final String? gender;

  const CharacterFilterResult({this.status, this.species, this.gender});
}

/// Bottom sheet for choosing status/species/gender together, applied as
/// one combined action. Opened via [showCharacterFilterSheet].
///
/// Every chip and the species field carry the same thin gold border used
/// on the cards/search bar ([AppColors.goldBorderFor]) for one cohesive
/// design system, chips give a quick tap pulse via [TapPulse] instead of
/// an instant color snap, and the whole sheet fades/settles in on open
/// for a smoother-feeling reveal than the bare default transition.
class CharacterFilterSheet extends StatefulWidget {
  final String? initialStatus;
  final String? initialSpecies;
  final String? initialGender;

  const CharacterFilterSheet({
    super.key,
    this.initialStatus,
    this.initialSpecies,
    this.initialGender,
  });

  @override
  State<CharacterFilterSheet> createState() => _CharacterFilterSheetState();
}

class _CharacterFilterSheetState extends State<CharacterFilterSheet> {
  static const List<String> _statuses = ['Alive', 'Dead', 'unknown'];
  static const List<String> _genders = [
    'Female',
    'Male',
    'Genderless',
    'unknown'
  ];

  String? _status;
  String? _gender;
  late final TextEditingController _speciesController;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _gender = widget.initialGender;
    _speciesController =
        TextEditingController(text: widget.initialSpecies ?? '');
  }

  @override
  void dispose() {
    _speciesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color goldBorder = AppColors.goldBorderFor(theme.brightness);
    final BorderRadius fieldRadius = BorderRadius.circular(14.r);

    final Widget content = Padding(
      padding: EdgeInsets.fromLTRB(
          20.w, 12.h, 20.w, 20.h + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: goldBorder.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text('Filter characters',
              style: theme.textTheme.titleLarge?.copyWith(letterSpacing: 0.2)),
          SizedBox(height: 22.h),
          _FilterSection(
            title: 'Status',
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _statuses.map((s) {
                final bool selected = _status == s;
                return TapPulse(
                  child: ChoiceChip(
                    label: Text(s),
                    selected: selected,
                    side: BorderSide(
                        color:
                            goldBorder.withValues(alpha: selected ? 0.9 : 0.5)),
                    onSelected: (_) =>
                        setState(() => _status = selected ? null : s),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.h),
          _FilterSection(
            title: 'Gender',
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _genders.map((g) {
                final bool selected = _gender == g;
                return TapPulse(
                  child: ChoiceChip(
                    label: Text(g),
                    selected: selected,
                    side: BorderSide(
                        color:
                            goldBorder.withValues(alpha: selected ? 0.9 : 0.5)),
                    onSelected: (_) =>
                        setState(() => _gender = selected ? null : g),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.h),
          _FilterSection(
            title: 'Species',
            child: TextField(
              controller: _speciesController,
              decoration: InputDecoration(
                hintText: 'e.g. Human, Alien…',
                border: OutlineInputBorder(
                  borderRadius: fieldRadius,
                  borderSide:
                      BorderSide(color: goldBorder.withValues(alpha: 0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: fieldRadius,
                  borderSide:
                      BorderSide(color: goldBorder.withValues(alpha: 0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: fieldRadius,
                  borderSide: BorderSide(color: goldBorder, width: 1.4),
                ),
              ),
            ),
          ),
          SizedBox(height: 26.h),
          Row(
            children: [
              Expanded(
                child: TapPulse(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side:
                          BorderSide(color: goldBorder.withValues(alpha: 0.7)),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: fieldRadius),
                    ),
                    onPressed: () => Navigator.of(context)
                        .pop(const CharacterFilterResult()),
                    child: const Text('Clear'),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TapPulse(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: fieldRadius,
                        side: BorderSide(
                            color: goldBorder.withValues(alpha: 0.6)),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pop(CharacterFilterResult(
                      status: _status,
                      species: _speciesController.text.trim().isEmpty
                          ? null
                          : _speciesController.text.trim(),
                      gender: _gender,
                    )),
                    child: const Text('Apply'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return content.animate().fadeIn(duration: 220.ms, curve: Curves.easeOut);
  }
}

/// A titled group inside the filter sheet — pulls the "Status" / "Gender"
/// / "Species" grouping into one small widget so the sheet's build method
/// stays about layout rather than repeating the same title-then-content
/// pattern three times, and keeps the visual grouping consistent.
class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium?.copyWith(letterSpacing: 0.2)),
        SizedBox(height: 10.h),
        child,
      ],
    );
  }
}

/// Opens [CharacterFilterSheet] and returns the chosen result, or null if
/// dismissed without a choice.
Future<CharacterFilterResult?> showCharacterFilterSheet(
  BuildContext context, {
  String? initialStatus,
  String? initialSpecies,
  String? initialGender,
}) {
  return showModalBottomSheet<CharacterFilterResult>(
    context: context,
    isScrollControlled: true,
    builder: (context) => CharacterFilterSheet(
      initialStatus: initialStatus,
      initialSpecies: initialSpecies,
      initialGender: initialGender,
    ),
  );
}
