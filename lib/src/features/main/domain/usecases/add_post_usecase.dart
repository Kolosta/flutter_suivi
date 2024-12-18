import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class AddPostUseCase implements UseCase<void, PostEntity> {
  final PostRepository repository;

  AddPostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(PostEntity post) async {
    return await repository.addPost(post);
  }
}