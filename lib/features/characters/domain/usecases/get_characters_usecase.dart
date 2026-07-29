import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/characters_result_entity.dart';
import '../repositories/characters_repository.dart';

class GetCharactersUseCase implements UseCase<CharactersResultEntity, GetCharactersParams> {
  final CharactersRepository repository;

  const GetCharactersUseCase(this.repository);

  @override
  Future<Either<Failure, CharactersResultEntity>> call(GetCharactersParams params) {
    return repository.getCharacters(
      page: params.page,
      name: params.name,
      status: params.status,
      species: params.species,
      gender: params.gender,
    );
  }
}

class GetCharactersParams extends Equatable {
  final int page;
  final String? name;
  final String? status;
  final String? species;
  final String? gender;

  const GetCharactersParams({
    this.page = 1,
    this.name,
    this.status,
    this.species,
    this.gender,
  });

  @override
  List<Object?> get props => [page, name, status, species, gender];
}