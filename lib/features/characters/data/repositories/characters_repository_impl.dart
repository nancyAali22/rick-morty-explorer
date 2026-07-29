import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/characters_result_entity.dart';
import '../../domain/repositories/characters_repository.dart';
import '../../domain/usecases/get_characters_usecase.dart';
import '../datasources/characters_remote_datasource.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharactersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const CharactersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CharactersResultEntity>> getCharacters({
    required int page,
    String? name,
    String? status,
    String? species,
    String? gender,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await remoteDataSource.getCharacters(
        GetCharactersParams(
          page: page,
          name: name,
          status: status,
          species: species,
          gender: gender,
        ),
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}