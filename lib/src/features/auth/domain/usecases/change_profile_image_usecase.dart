import 'dart:io';

import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ChangeProfileImageUseCase {
  final AuthRepository repository;

  ChangeProfileImageUseCase(this.repository);

  Future<Either<Failure, String>> changeProfileImage(File imageFile) {
    return repository.changeProfileImage(imageFile);
  }
}