import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:tp1_flutter/src/features/main/di/post_dependency.dart';

import 'injector.dart';

final getIt = GetIt.I;

void configureDependencies() {
  AuthDepedency.init();
  PostDependency.init();
  // ProductDependency.init();
  // AnilistUserDependency.init();
  // AnimeDependency.init();

  getIt.registerLazySingleton(
        () => ThemeBloc(),
  );

  getIt.registerLazySingleton(
        () => TranslateBloc(),
  );

  getIt.registerLazySingleton(
        () => AppRouteConf(),
  );

  getIt.registerLazySingleton(
        () => ApiHelper(
      getIt<Dio>(),
    ),
  );

  getIt.registerLazySingleton(
        () => Dio()
      ..interceptors.add(
        getIt<ApiInterceptor>(),
      ),
  );

  getIt.registerLazySingleton(
        () => ApiInterceptor(),
  );

  getIt.registerLazySingleton(
        () => SecureLocalStorage(
      getIt<FlutterSecureStorage>(),
    ),
  );

  getIt.registerLazySingleton(
        () => HiveLocalStorage(),
  );

  // getIt.registerLazySingleton(
  //       () => NetworkInfo(
  //     getIt<InternetConnectionChecker>(),
  //   ),
  // );

  // getIt.registerLazySingleton(
  //       () => InternetConnectionChecker(),
  // );

  getIt.registerLazySingleton(
        () => const FlutterSecureStorage(),
  );
}
