import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class GetPostsByIdsUseCase implements UseCase<List<PostEntity>, List<String>> {
  final PostRepository repository;

  GetPostsByIdsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostEntity>>> call(List<String> ids) async {
    return await repository.getPostsByIds(ids);
  }
}