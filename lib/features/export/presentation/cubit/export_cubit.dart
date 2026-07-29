import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../characters/domain/entities/character_entity.dart';
import '../../domain/usecases/export_characters_usecase.dart';

import 'export_state.dart';

/// A small, single-purpose Cubit for the export flow only.
///
/// Kept separate from [CharactersCubit] on purpose (SRP): that Cubit
/// owns fetching/searching/filtering the character list; this one owns
/// turning "whatever list is currently on screen" into a saved .xlsx
/// file. [CharactersPage] reads the current list straight out of
/// [CharactersState] and hands it to this Cubit's [exportCharacters] —
/// this Cubit never reaches into `CharactersCubit` itself, so the two
/// features stay decoupled and each stays easy to test in isolation.
class ExportCubit extends Cubit<ExportState> {
  final ExportCharactersUseCase _exportCharactersUseCase;

  ExportCubit(this._exportCharactersUseCase) : super(ExportState.idle());

  Future<void> exportCharacters(List<CharacterEntity> characters) async {
    if (state.status == ExportStatus.exporting) return;

    emit(state.copyWith(status: ExportStatus.exporting));

    final result = await _exportCharactersUseCase(
      ExportCharactersParams(characters),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
            status: ExportStatus.error, errorMessage: failure.message),
      ),
      (path) => emit(
        state.copyWith(status: ExportStatus.success, filePath: path),
      ),
    );
  }

  /// Called after the UI has shown the success/error feedback, so a
  /// second export attempt starts from a clean `idle` state instead of
  /// re-showing the previous snackbar via BlocListener's `listenWhen`.
  void reset() {
    if (state.status != ExportStatus.idle) emit(ExportState.idle());
  }
}
