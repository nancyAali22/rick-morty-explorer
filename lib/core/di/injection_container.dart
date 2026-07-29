import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';

/// Single service locator for the whole app. Every feature will register
/// its own dependencies here via a `_initCharactersFeature()`-style
/// function, keeping this file from becoming a God file as features grow.
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  _initCore();
  // _initCharactersFeature();  // registered in Phase 2
  // _initExportFeature();      // registered in Phase 4
}

void _initCore() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}
