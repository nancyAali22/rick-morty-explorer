import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/characters_cubit.dart';

/// A plain text field wired to [CharactersCubit.search]. The debounce
/// timer itself lives in the Cubit — this widget only forwards keystrokes,
/// so it stays a pure UI component with zero business logic.
class CharacterSearchBar extends StatefulWidget {
  const CharacterSearchBar({super.key});

  @override
  State<CharacterSearchBar> createState() => _CharacterSearchBarState();
}

class _CharacterSearchBarState extends State<CharacterSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Seed with whatever query is already in the Cubit, so the field
    // reflects the preserved search when navigating back to this screen.
    _controller = TextEditingController(text: context.read<CharactersCubit>().state.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) => context.read<CharactersCubit>().search(value),
      textInputAction: TextInputAction.search,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: 'Search characters…',
        prefixIcon: Icon(Icons.search_rounded, size: 20.sp),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.close_rounded, size: 18.sp),
              onPressed: () {
                _controller.clear();
                context.read<CharactersCubit>().search('');
              },
            );
          },
        ),
      ),
    );
  }
}