import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure([this.message = ""]); //Crochets pour le rendre optionnel

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {}

class EmptyFailure extends Failure {}

class CredentialFailure extends Failure {}

class DuplicateEmailFailure extends Failure {}

class PasswordNotMatchFailure extends Failure {}

class InvalidEmailFailure extends Failure {}

class InvalidPasswordFailure extends Failure {}

class TypeMismatchFailure extends Failure {
  final String message;

  TypeMismatchFailure(this.message);

  @override
  List<Object> get props => [message];
}

class UnexpectedFailure extends Failure {
  final String message;

  UnexpectedFailure(this.message);

  @override
  List<Object> get props => [message];
}