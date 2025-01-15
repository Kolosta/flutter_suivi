import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp1_flutter/src/core/api/api_url.dart';
import 'package:tp1_flutter/src/features/main/data/models/post_model.dart';
import 'package:tp1_flutter/src/core/errors/exceptions.dart';
import 'package:tp1_flutter/src/core/utils/logger.dart';

import '../../../../configs/injector/injector.dart';
import '../models/delete_post_model.dart';
import '../models/toggle_like_model.dart';
import '../../domain/entities/post_user_entity.dart';

sealed class PostRemoteDataSource {
  Future<List<PostModel>> fetchPosts();
  Future<List<PostModel>> getPostsByIds(List<String> ids);
  Future<void> addPost(PostModel model);
  Future<void> updatePost(PostModel model);
  Future<void> deletePost(DeletePostModel postModel);
  Future<void> toggleLike(ToggleLikeModel model);
  // Future<List<PostModel>> getComments(String postId);
  Future<List<String>> getCommentIds(String postId);
  Future<PostModel> getCommentById(String commentId);
  // Future<void> addComment(String postId, String content);
  Future<void> addComment(String postId, PostModel model);
  Future<PostUserEntity> fetchUserDetails(String ownerId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  // final FirebaseFirestore _firestore;
  final ApiHelper _helper;

  const PostRemoteDataSourceImpl(this._helper);

  @override
  Future<List<PostModel>> fetchPosts() async {
    try {
      // final response = await _firestore.collection('posts').get();
      // final response = await ApiUrl.posts.get();

      final response = await ApiUrl.posts.where('isComment', isEqualTo: false).get();
      return response.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<List<PostModel>> getPostsByIds(List<String> ids) async {
    try {
      final response = await ApiUrl.posts.where(FieldPath.documentId, whereIn: ids).get();
      return response.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> addPost(PostModel model) async {
    try {
      // await _firestore.collection('posts').add(model.toJson());
      // await ApiUrl.posts.add(model.toJson());
      await ApiUrl.posts.doc(model.id).set(model.toJson());
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> updatePost(PostModel model) async {
    try {
      // await _firestore.collection('posts').doc(model.id).update(model.toJson());
      await ApiUrl.posts.doc(model.id).update(model.toJson());
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  //TODO : Quand on delete un post, il faut aussi le delete des listes commentIds des autres posts si jamais c'était un commentaire. de façon récursive
  // @override
  // Future<void> deletePost(DeletePostModel postModel) async {
  //   try {
  //     // await _firestore.collection('posts').doc(postId).delete()
  //     await ApiUrl.posts.doc(postModel.id).delete();
  //   } catch (e) {
  //     logger.e(e);
  //     throw ServerException();
  //   }
  // }
  @override
  Future<void> deletePost(DeletePostModel postModel) async {
    try {
      // Fetch the post to check if it is a comment
      // final postSnapshot = await ApiUrl.posts.doc(postModel.id).get();
      // if (!postSnapshot.exists) {
      //   throw ServerException();
      // }
      //
      // final post = PostModel.fromJson(postSnapshot.data()!);

      // If the post is a comment, remove it from the commentIds of other posts
      if (postModel.isComment) {
        final parentPostsSnapshot = await ApiUrl.posts
            .where('commentIds', arrayContains: postModel.id)
            .get();

        for (var doc in parentPostsSnapshot.docs) {
          await doc.reference.update({
            'commentIds': FieldValue.arrayRemove([postModel.id])
          });
        }
      }

      // Delete the post
      await ApiUrl.posts.doc(postModel.id).delete();
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  // @override
  // Future<List<PostModel>> getComments(String postId) async {
  //   try {
  //     final response = await ApiUrl.posts.doc(postId).collection('comments').get();
  //     return response.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
  //   } catch (e) {
  //     logger.e(e);
  //     throw ServerException();
  //   }
  // }
  @override
  Future<List<String>> getCommentIds(String postId) async {
    try {
      final response = await ApiUrl.posts.doc(postId).get();
      return List<String>.from(response.data()?['commentIds'] ?? []);
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<PostModel> getCommentById(String commentId) async {
    try {
      final response = await ApiUrl.posts.doc(commentId).get();
      return PostModel.fromJson(response.data()!);
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  // @override
  // Future<void> addComment(String postId, String content) async {
  //   try {
  //     await ApiUrl.posts.doc(postId).collection('comments').add({'content': content});
  //   } catch (e) {
  //     logger.e(e);
  //     throw ServerException();
  //   }
  // }
  @override
  Future<void> addComment(String postId, PostModel model) async {
    try {
      final newCommentRef = ApiUrl.posts.doc(model.id);

      // Add the new comment
      await newCommentRef.set(model.toJson());

      // Update the post to include the new comment ID
      await ApiUrl.posts.doc(postId).update({
        'commentIds': FieldValue.arrayUnion([model.id])
      });
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> toggleLike(ToggleLikeModel model) async {
    try {
      final docRef = ApiUrl.posts.doc(model.postId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw ServerException();
      }

      final likes = List<String>.from(docSnapshot.data()!['likes']);
      if (likes.contains(model.userId)) {
        await docRef.update({
          'likes': FieldValue.arrayRemove([model.userId])
        });
      } else {
        await docRef.update({
          'likes': FieldValue.arrayUnion([model.userId])
        });
      }
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<PostUserEntity> fetchUserDetails(String ownerId) async {
    try {
      final response = await ApiUrl.users.doc(ownerId).get();
      if (response.exists) {
        final data = response.data()!;
        return PostUserEntity(
          userId: ownerId,
          username: data['username'],
          email: data['email'],
          profileImage: data['profileImage'],
        );
      } else {
        throw ServerException();
      }
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

}