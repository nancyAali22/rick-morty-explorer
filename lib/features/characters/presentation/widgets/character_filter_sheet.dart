import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  static const List<String> _genders = ['Female', 'Male', 'Genderless', 'unknown'];

  String? _status;
  String? _gender;
  late final TextEditingController _speciesController;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _gender = widget.initialGender;
    _speciesController = TextEditingController(text: widget.initialSpecies ?? '');
  }

  @override
  void dispose() {
    _speciesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text('Filter characters', style: theme.textTheme.titleLarge),
          SizedBox(height: 20.h),
          Text('Status', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: _statuses.map((s) {
              final selected = _status == s;
              return ChoiceChip(
                label: Text(s),
                selected: selected,
                onSelected: (_) => setState(() => _status = selected ? null : s),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),
          Text('Gender', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: _genders.map((g) {
              final selected = _gender == g;
              return ChoiceChip(
                label: Text(g),
                selected: selected,
                onSelected: (_) => setState(() => _gender = selected ? null : g),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h),
          Text('Species', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          TextField(
            controller: _speciesController,
            decoration: const InputDecoration(hintText: 'e.g. Human, Alien…'),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(const CharacterFilterResult()),
                  child: const Text('Clear'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(CharacterFilterResult(
                    status: _status,
                    species: _speciesController.text.trim().isEmpty ? null : _speciesController.text.trim(),
                    gender: _gender,
                  )),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
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