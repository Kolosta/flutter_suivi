import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class AddCommentUseCase implements UseCase<void, AddCommentParams> {
  final PostRepository repository;

  AddCommentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddCommentParams params) async {
    return await repository.addComment(params);
  }
}

class AddCommentParams {
  final String postId;
  final PostEntity comment;

  AddCommentParams(this.postId, this.comment);
}