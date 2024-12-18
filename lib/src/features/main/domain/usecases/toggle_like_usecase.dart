import 'package:fpdart/fpdart.dart';
import 'package:tp1_flutter/src/core/usecases/usecase.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/toggle_like_model.dart';
import '../repositories/post_repository.dart';

class ToggleLikeUsecase implements UseCase<void, ToggleLikeModel> {
  final PostRepository _repository;
  const ToggleLikeUsecase(this._repository);

  @override
  Future<Either<Failure, void>> call(ToggleLikeModel model) {
    return _repository.toggleLike(model);
  }
}


class Params {
  final String postId;

  Params({required this.postId});

  @override
  List<Object> get props => [postId];
}