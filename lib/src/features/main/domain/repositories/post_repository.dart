import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/delete_post_model.dart';
import '../../data/models/toggle_like_model.dart';
import '../entities/post_entity.dart';
import '../usecases/add_comment_usecase.dart';
import '../../domain/entities/post_user_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts();
  Future<Either<Failure, List<PostEntity>>> getPostsByIds(List<String> ids);
  Future<Either<Failure, void>> addPost(PostEntity post);
  Future<Either<Failure, void>> deletePost(DeletePostModel postModel);
  Future<Either<Failure, void>> toggleLike(ToggleLikeModel post);
  Future<Either<Failure, List<PostEntity>>> getComments(String postId);
  Future<Either<Failure, void>> addComment(AddCommentParams params);
  Future<Either<Failure, PostUserEntity>> fetchUserDetails(String ownerId);
}