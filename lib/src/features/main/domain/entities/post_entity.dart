import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String? ownerId;
  final String? content;
  final List<String>? imagePaths;
  final List<String>? imageUrls;
  final List<String>? likes;
  final List<String>? commentIds;
  final bool isComment;


  PostEntity({
    required this.id,
    this.ownerId,
    this.content,
    this.imagePaths,
    this.imageUrls,
    this.likes,
    this.commentIds,
    this.isComment = false,
  });

  @override
  List<Object?> get props => [id, ownerId, content, imagePaths, imageUrls, likes, commentIds, isComment];

  PostEntity copyWith({
    String? id,
    String? ownerId,
    String? content,
    List<String>? imagePaths,
    List<String>? imageUrls,
    List<String>? likes,
    List<String>? commentIds,
    bool? isComment,
  }) {
    return PostEntity(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      content: content ?? this.content,
      imagePaths: imagePaths ?? this.imagePaths,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? commentIds,
      isComment: isComment ?? this.isComment,
    );
  }
}