import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/usecases/get_characters_usecase.dart';
import 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final GetCharactersUseCase _getCharactersUseCase;
  Timer? _debounce;

  CharactersCubit(this._getCharactersUseCase) : super(CharactersState.initial());

  Future<void> loadFirstPage() async {
    emit(state.copyWith(
      status: CharactersStatus.firstLoading,
      currentPage: 1,
      hasReachedMax: false,
      errorMessage: null,
      isPaginationError: false,
    ));

    final result = await _getCharactersUseCase(_paramsForPage(1));

    result.fold(
          (failure) => emit(state.copyWith(
        status: CharactersStatus.error,
        errorMessage: failure.message,
        isPaginationError: false,
      )),
          (data) {
        if (data.characters.isEmpty) {
          emit(state.copyWith(
            status: CharactersStatus.empty,
            characters: const [],
            currentPage: 1,
            hasReachedMax: true,
          ));
        } else {
          emit(state.copyWith(
            status: CharactersStatus.success,
            characters: data.characters,
            currentPage: 1,
            hasReachedMax: !data.info.hasNextPage,
          ));
        }
      },
    );
  }

  /// Pull-to-refresh is just a first-page reload — kept as a distinct,
  /// well-named entry point so the UI intent stays explicit.
  Future<void> refresh() => loadFirstPage();

  /// Loads the next page and appends it to the current list.
  /// Guards against duplicate/overlapping requests and over-fetching.
  Future<void> loadNextPage() async {
    final bool alreadyBusy = state.status == CharactersStatus.firstLoading ||
        state.status == CharactersStatus.loadingMore;

    if (state.hasReachedMax || alreadyBusy) return;

    emit(state.copyWith(status: CharactersStatus.loadingMore));

    final int nextPage = state.currentPage + 1;
    final result = await _getCharactersUseCase(_paramsForPage(nextPage));

    result.fold(
          (failure) => emit(state.copyWith(
        // Keep the existing list visible; only flag a pagination error
        // so the UI can show a lightweight retry affordance.
        status: CharactersStatus.success,
        errorMessage: failure.message,
        isPaginationError: true,
      )),
          (data) => emit(state.copyWith(
        status: CharactersStatus.success,
        characters: [...state.characters, ...data.characters],
        currentPage: nextPage,
        hasReachedMax: !data.info.hasNextPage,
        errorMessage: null,
        isPaginationError: false,
      )),
    );
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      if (query == state.searchQuery) return;
      emit(state.copyWith(searchQuery: query, characters: const []));
      loadFirstPage();
    });
  }

  void applyFilters({String? status, String? species, String? gender}) {
    emit(state.copyWith(
      statusFilter: status,
      speciesFilter: species,
      genderFilter: gender,
      characters: const [],
    ));
    loadFirstPage();
  }

  void clearFilters() {
    if (!state.hasActiveFilters) return;
    emit(state.copyWith(
      statusFilter: null,
      speciesFilter: null,
      genderFilter: null,
      characters: const [],
    ));
    loadFirstPage();
  }

  GetCharactersParams _paramsForPage(int page) {
    return GetCharactersParams(
      page: page,
      name: state.searchQuery.isEmpty ? null : state.searchQuery,
      status: state.statusFilter,
      species: state.speciesFilter,
      gender: state.genderFilter,
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}