import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../../features/characters/data/datasources/characters_remote_datasource.dart';
import '../../features/characters/data/repositories/characters_repository_impl.dart';
import '../../features/characters/domain/repositories/characters_repository.dart';
import '../../features/characters/domain/usecases/get_characters_usecase.dart';
import '../../features/characters/presentation/cubit/characters_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  _initCore();
  _initCharactersFeature();
  // _initExportFeature();      // registered in Phase 4
}

void _initCore() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

void _initCharactersFeature() {

  sl.registerLazySingleton<CharactersRemoteDataSource>(
        () => CharactersRemoteDataSourceImpl(sl<DioClient>().dio),
  );

  sl.registerLazySingleton<CharactersRepository>(
        () => CharactersRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<GetCharactersUseCase>(
        () => GetCharactersUseCase(sl()),
  );

  sl.registerLazySingleton<CharactersCubit>(
        () => CharactersCubit(sl()),
  );
}