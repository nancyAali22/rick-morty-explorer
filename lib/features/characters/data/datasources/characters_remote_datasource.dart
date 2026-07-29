import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/usecases/get_characters_usecase.dart';
import '../models/characters_result_model.dart';

abstract class CharactersRemoteDataSource {
  Future<CharactersResultModel> getCharacters(GetCharactersParams params);
}

class CharactersRemoteDataSourceImpl implements CharactersRemoteDataSource {
  final Dio dio;

  const CharactersRemoteDataSourceImpl(this.dio);

  @override
  Future<CharactersResultModel> getCharacters(GetCharactersParams params) async {
    try {
      final Response response = await dio.get(
        ApiConstants.characterEndpoint,
        queryParameters: {
          ApiConstants.queryPage: params.page,
          if (params.name != null && params.name!.isNotEmpty)
            ApiConstants.queryName: params.name,
          if (params.status != null && params.status!.isNotEmpty)
            ApiConstants.queryStatus: params.status,
          if (params.species != null && params.species!.isNotEmpty)
            ApiConstants.querySpecies: params.species,
          if (params.gender != null && params.gender!.isNotEmpty)
            ApiConstants.queryGender: params.gender,
        },
      );

      return CharactersResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {

      if (e.response?.statusCode == 404) {
        return CharactersResultModel.empty();
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Connection timed out. Check your internet.');
      }

      throw ServerException(
        e.response?.statusMessage ?? 'Unexpected server error (${e.response?.statusCode}).',
      );
    } catch (_) {
      throw const ServerException('Failed to parse character data.');
    }
  }
}