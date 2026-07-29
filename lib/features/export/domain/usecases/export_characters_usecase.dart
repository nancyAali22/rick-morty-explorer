import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../characters/domain/entities/character_entity.dart';
import '../../services/excel_builder_service.dart';
import '../../services/file_saver_service.dart';

class ExportCharactersParams {
  final List<CharacterEntity> characters;

  const ExportCharactersParams(this.characters);
}

/// Orchestrates the export flow: build workbook bytes, then save them
/// to disk.
///
/// Why this is a UseCase and not a full domain/repository split:
/// there's no remote or swappable data source to abstract behind an
/// interface here — both steps are local and synchronous. A
/// `ExportRepository` interface with a single implementation would just
/// be indirection for its own sake. What *is* worth keeping is the same
/// `Either<Failure, Type>` contract every other UseCase in this app
/// uses, purely so [ExportCubit] can consume this exactly the way
/// [CharactersCubit] consumes [GetCharactersUseCase] — one consistent
/// pattern across the codebase, not two.
class ExportCharactersUseCase
    implements UseCase<String, ExportCharactersParams> {
  final ExcelBuilderService _builder;
  final FileSaverService _saver;

  const ExportCharactersUseCase(this._builder, this._saver);

  @override
  Future<Either<Failure, String>> call(ExportCharactersParams params) async {
    if (params.characters.isEmpty) {
      return const Left(
        ExportFailure('There is nothing to export yet.'),
      );
    }

    try {
      final List<int> bytes = _builder.build(params.characters);
      final String fileName = _saver.buildFileName();
      final file = await _saver.save(bytes, fileName: fileName);
      return Right(file.path);
    } catch (_) {
      return const Left(ExportFailure());
    }
  }
}
