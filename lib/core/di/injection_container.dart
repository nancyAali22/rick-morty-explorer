import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../theme/cubit/theme_cubit.dart';
import '../theme/theme_mode_storage.dart';
import '../../features/characters/data/datasources/characters_remote_datasource.dart';
import '../../features/characters/data/repositories/characters_repository_impl.dart';
import '../../features/characters/domain/repositories/characters_repository.dart';
import '../../features/characters/domain/usecases/get_characters_usecase.dart';
import '../../features/characters/presentation/cubit/characters_cubit.dart';
import '../../features/export/services/excel_builder_service.dart';
import '../../features/export/services/file_saver_service.dart';
import '../../features/export/domain/usecases/export_characters_usecase.dart';
import '../../features/export/presentation/cubit/export_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();
  _initCharactersFeature();
  _initExportFeature();
  await _initThemeFeature();
}

Future<void> _initCore() async {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
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

void _initExportFeature() {
  // Stateless, no-I/O building blocks — safe as lazy singletons.
  sl.registerLazySingleton<ExcelBuilderService>(() => ExcelBuilderService());
  sl.registerLazySingleton<FileSaverService>(() => FileSaverService());

  sl.registerLazySingleton<ExportCharactersUseCase>(
    () => ExportCharactersUseCase(sl(), sl()),
  );

  // registerFactory (not lazySingleton): CharactersPage creates a fresh
  // ExportCubit each time it's built and disposes it on unmount — unlike
  // CharactersCubit, this Cubit has no state worth keeping across
  // navigations (an export from a previous visit is already finished).
  sl.registerFactory<ExportCubit>(() => ExportCubit(sl()));
}

Future<void> _initThemeFeature() async {
  sl.registerLazySingleton<ThemeModeStorage>(() => ThemeModeStorageImpl(sl()));

  // Loaded here — before runApp — rather than inside ThemeCubit's
  // constructor, so the very first frame already renders the saved
  // mode instead of flashing light-mode-then-restoring dark.
  final ThemeMode initialThemeMode =
      await sl<ThemeModeStorage>().loadThemeMode();

  // lazySingleton, provided once at the app root (see main.dart) — theme
  // is app-global state read by every route, unlike ExportCubit above.
  sl.registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(sl(), initialThemeMode));
}
