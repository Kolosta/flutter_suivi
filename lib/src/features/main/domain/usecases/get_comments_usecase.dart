import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetCommentsUseCase implements UseCase<List<PostEntity>, String> {
  final PostRepository repository;

  GetCommentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(String postId) async {
    return await repository.getComments(postId);
  }
}