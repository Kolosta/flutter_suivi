import 'package:flutter_bloc/flutter_bloc.dart';

import 'logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e(error);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    // logger.d(change.currentState);
    // logger.d(change.nextState);

    const int maxLength = 300; // Limite de caractères

    String truncate(String str) {
      return (str.length > maxLength) ? '${str.substring(0, maxLength)}...' : str;
    }

    logger.d('${bloc.runtimeType} : ${truncate(change.currentState.toString())}, ==> ${truncate(change.nextState.toString())}');



    // logger.d('${bloc.runtimeType} : ${change.currentState}, ==> ${change.nextState}');
    super.onChange(bloc, change);
  }
}