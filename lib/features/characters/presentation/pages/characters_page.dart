import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../../export/presentation/cubit/export_cubit.dart';
import '../../../export/presentation/cubit/export_state.dart';
import '../../../export/widgets/export_fab_button.dart';
import '../cubit/characters_cubit.dart';
import '../cubit/characters_state.dart';
import '../widgets/character_card.dart';
import '../widgets/character_filter_sheet.dart';
import '../widgets/character_search_bar.dart';
import '../widgets/characters_app_bar.dart';
import '../widgets/characters_empty_state.dart';
import '../widgets/characters_error_state.dart';
import '../widgets/characters_skeleton_grid.dart';

/// The Characters list screen. Purely orchestration: reads [CharactersCubit]
/// and [ExportCubit] state and renders the matching widget — no business
/// logic lives here.
class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // sl<CharactersCubit>() always returns the same lazySingleton instance,
    // so re-entering this route never loses the current search/filters.
    // sl<ExportCubit>() is a factory: a fresh export flow every visit.
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<CharactersCubit>()),
        BlocProvider(create: (_) => sl<ExportCubit>()),
      ],
      child: const _CharactersView(),
    );
  }
}

class _CharactersView extends StatefulWidget {
  const _CharactersView();

  @override
  State<_CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<_CharactersView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CharactersCubit>();
    if (cubit.state.status == CharactersStatus.initial) {
      cubit.loadFirstPage();
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final threshold = _scrollController.position.maxScrollExtent - 300.h;
    if (_scrollController.position.pixels >= threshold) {
      context.read<CharactersCubit>().loadNextPage();
    }
  }

  int _crossAxisCountFor(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openFilterSheet() async {
    final cubit = context.read<CharactersCubit>();
    final result = await showCharacterFilterSheet(
      context,
      initialStatus: cubit.state.statusFilter,
      initialSpecies: cubit.state.speciesFilter,
      initialGender: cubit.state.genderFilter,
    );
    if (result == null) return;
    cubit.applyFilters(status: result.status, species: result.species, gender: result.gender);
  }

  void _handleExport() {
    final characters = context.read<CharactersCubit>().state.characters;

    if (characters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing to export yet — try clearing your search or filters.'),
        ),
      );
      return;
    }

    context.read<ExportCubit>().exportCharacters(characters);
  }

  void _handleExportStatusChange(BuildContext context, ExportState state) {
    final messenger = ScaffoldMessenger.of(context);
    final exportCubit = context.read<ExportCubit>();

    switch (state.status) {
      case ExportStatus.success:
        messenger.showSnackBar(
          SnackBar(
            content: const Text('Exported to Excel successfully.'),
            action: SnackBarAction(
              label: 'OPEN',
              onPressed: () => OpenFile.open(state.filePath),
            ),
          ),
        );
        exportCubit.reset();
        break;
      case ExportStatus.error:
        messenger.showSnackBar(
          SnackBar(content: Text(state.errorMessage ?? 'Could not export data to Excel.')),
        );
        exportCubit.reset();
        break;
      case ExportStatus.idle:
      case ExportStatus.exporting:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CharactersAppBar(),
      floatingActionButton: ExportFabButton(onPressed: _handleExport),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CharactersCubit, CharactersState>(
            listenWhen: (previous, current) =>
            current.isPaginationError && current.errorMessage != previous.errorMessage,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Could not load more characters.')),
              );
            },
          ),
          BlocListener<ExportCubit, ExportState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: _handleExportStatusChange,
          ),
        ],
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Row(
                children: [
                  const Expanded(child: CharacterSearchBar()),
                  SizedBox(width: 8.w),
                  BlocBuilder<CharactersCubit, CharactersState>(
                    buildWhen: (p, c) => p.hasActiveFilters != c.hasActiveFilters,
                    builder: (context, state) {
                      return IconButton.filledTonal(
                        onPressed: _openFilterSheet,
                        icon: Icon(
                          state.hasActiveFilters ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = _crossAxisCountFor(constraints.maxWidth);
                  return BlocBuilder<CharactersCubit, CharactersState>(
                    builder: (context, state) => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _buildBody(context, state, crossAxisCount),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CharactersState state, int crossAxisCount) {
    switch (state.status) {
      case CharactersStatus.initial:
      case CharactersStatus.firstLoading:
        return CharactersSkeletonGrid(key: const ValueKey('skeleton'), crossAxisCount: crossAxisCount);

      case CharactersStatus.error:
        return CharactersErrorState(
          key: const ValueKey('error'),
          message: state.errorMessage ?? 'Please try again.',
          onRetry: () => context.read<CharactersCubit>().loadFirstPage(),
        );

      case CharactersStatus.empty:
        return const CharactersEmptyState(key: ValueKey('empty'));

      case CharactersStatus.success:
      case CharactersStatus.loadingMore:
        return RefreshIndicator(
          key: const ValueKey('grid'),
          onRefresh: () => context.read<CharactersCubit>().refresh(),
          child: GridView.builder(
            // Keyed by the active search/filter signature (not just
            // 'grid') so a genuinely new result set gets a fresh
            // GridView subtree — which replays each CharacterCard's
            // staggered entrance animation — while scrolling/pagination
            // under the *same* filters keeps reusing existing card
            // elements (same key), so nothing replays on every rebuild.
            key: ValueKey(
              'grid-${state.searchQuery}|${state.statusFilter}|${state.speciesFilter}|${state.genderFilter}',
            ),
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 88.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.72,
            ),
            itemCount: state.characters.length + (state.status == CharactersStatus.loadingMore ? crossAxisCount : 0),
            itemBuilder: (context, index) {
              if (index >= state.characters.length) {
                return const _SkeletonFooterTile();
              }
              final character = state.characters[index];
              return CharacterCard(
                character: character,
                index: index,
                onTap: () => context.push(RouteNames.characterDetailsPath(character.id), extra: character),
              );
            },
          ),
        );
    }
  }
}

class _SkeletonFooterTile extends StatelessWidget {
  const _SkeletonFooterTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}