import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_explorer/core/error/failures.dart';
import 'package:rick_morty_explorer/features/characters/domain/entities/character_entity.dart';
import 'package:rick_morty_explorer/features/characters/domain/entities/characters_result_entity.dart';
import 'package:rick_morty_explorer/features/characters/domain/repositories/characters_repository.dart';
import 'package:rick_morty_explorer/features/characters/domain/usecases/get_characters_usecase.dart';

class MockCharactersRepository extends Mock implements CharactersRepository {}

void main() {
  late GetCharactersUseCase useCase;
  late MockCharactersRepository mockRepository;

  setUp(() {
    mockRepository = MockCharactersRepository();
    useCase = GetCharactersUseCase(mockRepository);
  });

  final tResult = CharactersResultEntity(
    characters: [
      CharacterEntity(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: const LocationRefEntity(name: 'Earth', url: ''),
        location: const LocationRefEntity(name: 'Earth', url: ''),
        image: '',
        episode: const [],
        url: '',
        created: DateTime(2017),
      ),
    ],
    info: const CharactersInfoEntity(count: 1, pages: 1),
  );

  test('should forward the exact params to the repository and return its result', () async {
    // arrange
    const params = GetCharactersParams(page: 1, name: 'rick');
    when(() => mockRepository.getCharacters(
      page: 1,
      name: 'rick',
      status: null,
      species: null,
      gender: null,
    )).thenAnswer((_) async => Right(tResult));

    // act
    final result = await useCase(params);

    // assert
    expect(result, Right(tResult));
    verify(() => mockRepository.getCharacters(
      page: 1,
      name: 'rick',
      status: null,
      species: null,
      gender: null,
    )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return the Failure from the repository unchanged on error', () async {
    // arrange
    const params = GetCharactersParams(page: 1);
    when(() => mockRepository.getCharacters(
      page: 1,
      name: null,
      status: null,
      species: null,
      gender: null,
    )).thenAnswer((_) async => const Left(NetworkFailure()));

    // act
    final result = await useCase(params);

    // assert
    expect(result, const Left(NetworkFailure()));
  });
}