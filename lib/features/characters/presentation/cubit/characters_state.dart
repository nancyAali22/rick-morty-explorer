import 'package:equatable/equatable.dart';
import '../../domain/entities/character_entity.dart';

enum CharactersStatus {
  initial,
  firstLoading,
  loadingMore,
  success,
  empty,
  error,
}

const Object _unset = Object();

class CharactersState extends Equatable {
  final CharactersStatus status;
  final List<CharacterEntity> characters;
  final int currentPage;
  final bool hasReachedMax;
  final String searchQuery;
  final String? statusFilter;
  final String? speciesFilter;
  final String? genderFilter;
  final String? errorMessage;

  final bool isPaginationError;

  const CharactersState({
    required this.status,
    required this.characters,
    required this.currentPage,
    required this.hasReachedMax,
    required this.searchQuery,
    this.statusFilter,
    this.speciesFilter,
    this.genderFilter,
    this.errorMessage,
    this.isPaginationError = false,
  });

  factory CharactersState.initial() => const CharactersState(
        status: CharactersStatus.initial,
        characters: [],
        currentPage: 1,
        hasReachedMax: false,
        searchQuery: '',
      );

  bool get hasActiveFilters =>
      statusFilter != null || speciesFilter != null || genderFilter != null;

  CharactersState copyWith({
    CharactersStatus? status,
    List<CharacterEntity>? characters,
    int? currentPage,
    bool? hasReachedMax,
    String? searchQuery,
    Object? statusFilter = _unset,
    Object? speciesFilter = _unset,
    Object? genderFilter = _unset,
    String? errorMessage,
    bool? isPaginationError,
  }) {
    return CharactersState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: identical(statusFilter, _unset)
          ? this.statusFilter
          : statusFilter as String?,
      speciesFilter: identical(speciesFilter, _unset)
          ? this.speciesFilter
          : speciesFilter as String?,
      genderFilter: identical(genderFilter, _unset)
          ? this.genderFilter
          : genderFilter as String?,
      errorMessage: errorMessage,
      isPaginationError: isPaginationError ?? false,
    );
  }

  @override
  List<Object?> get props => [
        status,
        characters,
        currentPage,
        hasReachedMax,
        searchQuery,
        statusFilter,
        speciesFilter,
        genderFilter,
        errorMessage,
        isPaginationError,
      ];
}
