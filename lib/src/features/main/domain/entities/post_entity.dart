import 'package:equatable/equatable.dart';
import 'package:tp1_flutter/src/features/main/domain/entities/post_user_entity.dart';

class PostEntity extends Equatable {
  final String id;
  // final String? ownerId;
  final PostUserEntity? owner;
  final String? content;
  final List<String>? imagePaths;
  final List<String>? imageUrls;
  final List<String>? likes;
  final List<String>? commentIds;
  final bool isComment;
  final String? username;
  final String? profileImage;

  PostEntity({
    required this.id,
    this.owner,
    this.content,
    this.imagePaths,
    this.imageUrls,
    this.likes,
    this.commentIds,
    this.isComment = false,
    this.username,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, owner, content, imagePaths, imageUrls, likes, commentIds, isComment, username, profileImage];

  PostEntity copyWith({
    String? id,
    PostUserEntity? owner,
    String? content,
    List<String>? imagePaths,
    List<String>? imageUrls,
    List<String>? likes,
    List<String>? commentIds,
    bool? isComment,
    String? username,
    String? profileImage,
  }) {
    return PostEntity(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      content: content ?? this.content,
      imagePaths: imagePaths ?? this.imagePaths,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? commentIds,
      isComment: isComment ?? this.isComment,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}