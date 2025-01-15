import 'package:fpdart/fpdart.dart';
import 'package:tp1_flutter/src/core/errors/exceptions.dart';
import 'package:tp1_flutter/src/core/errors/failures.dart';
import 'package:tp1_flutter/src/features/main/domain/entities/post_entity.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/usecases/add_comment_usecase.dart';
import '../datasources/post_remote_data_source.dart';
import '../models/delete_post_model.dart';
import '../models/models.dart';
import '../../domain/entities/post_user_entity.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;

  PostRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      final result = await _remoteDataSource.fetchPosts();
      final posts = result.map((postModel) => postModel.toEntity()).toList();
      return Right(posts);
    } on Exception {
      return Left(ServerFailure());
    }
  }


  @override
  Future<Either<Failure, List<PostEntity>>> getPostsByIds(List<String> ids) async {
    try {
      final result = await _remoteDataSource.getPostsByIds(ids);
      final posts = result.map((postModel) => postModel.toEntity()).toList();
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addPost(PostEntity post) async {
    try {
      final postModel = PostModel(
        id: post.id,
        owner: post.owner!,
        content: post.content ?? '',
        imagePaths: post.imagePaths ?? [],
        imageUrls: post.imageUrls ?? [],
        likes: post.likes ?? [],
        commentIds: post.commentIds ?? [],
        isComment: post.isComment,
      );

      final result = await _remoteDataSource.addPost(postModel);
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(DeletePostModel postModel) async {
    try {
      await _remoteDataSource.deletePost(postModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  // @override
  // Future<Either<Failure, List<PostEntity>>> getComments(String postId) async {
  //   try {
  //     final comments = await _remoteDataSource.getComments(postId);
  //     return Right(comments.map((model) => model.toEntity()).toList());
  //   } catch (e) {
  //     return Left(ServerFailure());
  //   }
  // }
  @override
  Future<Either<Failure, List<PostEntity>>> getComments(String postId) async {
    try {
      // Récupérer les IDs des commentaires
      final commentIds = await _remoteDataSource.getCommentIds(postId);

      // Récupérer chaque commentaire individuellement
      final comments = await Future.wait(commentIds.map((id) => _remoteDataSource.getCommentById(id)));

      return Right(comments.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure());
    }
  }



  // @override
  // Future<Either<Failure, void>> addComment(AddCommentParams params) async {
  //   try {
  //     await _remoteDataSource.addComment(params.postId, params.comment.content!);
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(ServerFailure());
  //   }
  // }
  @override
  Future<Either<Failure, void>> addComment(AddCommentParams params) async {
    try {
      logger.i('Adding comment: ${params.comment.content}');

      final postModel = PostModel(
        id: params.comment.id,
        owner: params.comment.owner!,
        content: params.comment.content ?? '',
        imagePaths: params.comment.imagePaths ?? [],
        imageUrls: params.comment.imageUrls ?? [],
        likes: params.comment.likes ?? [],
        commentIds: params.comment.commentIds ?? [],
        isComment: true,
      );

      await _remoteDataSource.addComment(params.postId, postModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleLike(ToggleLikeModel model) async {
    try {
      await _remoteDataSource.toggleLike(model);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, PostUserEntity>> fetchUserDetails(String ownerId) async {
    try {
      final user = await _remoteDataSource.fetchUserDetails(ownerId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}