import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'translate_event.dart';
part 'translate_state.dart';

class TranslateBloc extends HydratedBloc<TranslateEvent, TranslateState> {
  TranslateBloc() : super(const TranslateState("fr", "FR", "EN")) {
    on<TrFrenchEvent>(_trFrench);
    on<TrEnglishEvent>(_trEnglish);
  }

  Future _trFrench(TrFrenchEvent event, Emitter emit) async {
    emit(TranslateState("fr", "FR", state.countryCode));
  }

  Future _trEnglish(TrEnglishEvent event, Emitter emit) async {
    emit(TranslateState("en", "EN", state.countryCode));
  }

  @override
  TranslateState? fromJson(Map<String, dynamic> json) {
    return TranslateState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TranslateState state) {
    return state.toMap();
  }
}
