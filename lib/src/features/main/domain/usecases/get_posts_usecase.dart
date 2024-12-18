import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostsUseCase implements UseCase<List<PostEntity>, NoParams> {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(NoParams params) async {
    return await repository.getPosts();
  }
}