part of 'translate_bloc.dart';

sealed class TranslateEvent extends Equatable {
  const TranslateEvent();

  @override
  List<Object> get props => [];
}

class TrFrenchEvent extends TranslateEvent {}

class TrEnglishEvent extends TranslateEvent {}
