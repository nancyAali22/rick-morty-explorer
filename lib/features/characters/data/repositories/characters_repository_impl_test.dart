import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_morty_explorer/core/error/exceptions.dart';
import 'package:rick_morty_explorer/core/error/failures.dart';
import 'package:rick_morty_explorer/core/network/network_info.dart';
import 'package:rick_morty_explorer/features/characters/data/datasources/characters_remote_datasource.dart';
import 'package:rick_morty_explorer/features/characters/data/models/characters_result_model.dart';
import 'package:rick_morty_explorer/features/characters/data/repositories/characters_repository_impl.dart';
import 'package:rick_morty_explorer/features/characters/domain/usecases/get_characters_usecase.dart';

class MockRemoteDataSource extends Mock implements CharactersRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CharactersRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(const GetCharactersParams());
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CharactersRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('when device is offline', () {
    test('should return NetworkFailure without calling the data source', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getCharacters(page: 1);

      expect(result, const Left(NetworkFailure()));
      verifyNever(() => mockRemoteDataSource.getCharacters(any()));
    });
  });

  group('when device is online', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should return Right(result) on success', () async {
      final tModel = CharactersResultModel.empty();
      when(() => mockRemoteDataSource.getCharacters(any())).thenAnswer((_) async => tModel);

      final result = await repository.getCharacters(page: 1);

      expect(result, Right(tModel));
    });

    test('should return ServerFailure when ServerException is thrown', () async {
      when(() => mockRemoteDataSource.getCharacters(any()))
          .thenThrow(const ServerException('boom'));

      final result = await repository.getCharacters(page: 1);

      expect(result, const Left(ServerFailure('boom')));
    });

    test('should return NetworkFailure when NetworkException is thrown', () async {
      when(() => mockRemoteDataSource.getCharacters(any()))
          .thenThrow(const NetworkException('timeout'));

      final result = await repository.getCharacters(page: 1);

      expect(result, const Left(NetworkFailure('timeout')));
    });
  });
}