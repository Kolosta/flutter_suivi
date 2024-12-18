import 'package:tp1_flutter/src/app.dart';
import 'package:tp1_flutter/src/configs/adapter/adapter_conf.dart';
import 'package:tp1_flutter/src/configs/injector/injector_conf.dart';
import 'package:tp1_flutter/src/core/constants/list_translation_locale.dart';
import 'package:tp1_flutter/src/core/utils/observer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );


  configureAdapter();

  configureDependencies();

  Bloc.observer = AppBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [frenchLocale, englishLocale],
      path: "assets/translations",
      startLocale: frenchLocale,
      child: const MyApp(), //src/app.dart
    ),
  );
}

