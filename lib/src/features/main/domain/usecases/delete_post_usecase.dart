import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/delete_post_model.dart';
import '../repositories/post_repository.dart';

class DeletePostUseCase implements UseCase<void, DeletePostModel> {
  final PostRepository repository;

  DeletePostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletePostModel postModel) async {
    return await repository.deletePost(postModel);
  }
}