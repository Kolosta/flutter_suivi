import 'package:fpdart/fpdart.dart';
import 'package:tp1_flutter/src/features/main/domain/repositories/post_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/post_user_entity.dart';

class FetchUserDetailsUseCase implements UseCase<PostUserEntity, String> {
  final PostRepository repository;

  FetchUserDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, PostUserEntity>> call(String ownerId) async {
    return await repository.fetchUserDetails(ownerId);
  }
}