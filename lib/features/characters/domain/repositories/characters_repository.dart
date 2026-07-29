import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/characters_result_entity.dart';

abstract class CharactersRepository {
  Future<Either<Failure, CharactersResultEntity>> getCharacters({
    required int page,
    String? name,
    String? status,
    String? species,
    String? gender,
  });
}
