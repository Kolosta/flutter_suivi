import '../../domain/entities/post_entity.dart';

class PostModel {
  final String id;
  final String ownerId;
  final String content;
  final List<String> imagePaths;
  final List<String> imageUrls;
  final List<String> likes;
  final List<String> commentIds;
  final bool isComment;

  PostModel({
    required this.id,
    required this.ownerId,
    required this.content,
    required this.imagePaths,
    required this.imageUrls,
    required this.likes,
    required this.commentIds,
    required this.isComment,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      ownerId: json['ownerId'],
      content: json['content'],
      imagePaths: List<String>.from(json['imagePaths']),
      imageUrls: List<String>.from(json['imageUrls']),
      likes: List<String>.from(json['likes']),
      commentIds: List<String>.from(json['commentIds']),
      isComment: json['isComment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'content': content,
      'imagePaths': imagePaths,
      'imageUrls': imageUrls,
      'likes': likes,
      'commentIds': commentIds,
      'isComment': isComment,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'content': content,
      'imagePaths': imagePaths,
      'imageUrls': imageUrls,
      'likes': likes,
      'commentIds': commentIds,
      'isComment': isComment,
    };
  }

  PostModel copyWith({
    String? id,
    String? ownerId,
    String? content,
    List<String>? imagePaths,
    List<String>? imageUrls,
    List<String>? likes,
    List<String>? commentIds,
    bool? isComment,
  }) {
    return PostModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      content: content ?? this.content,
      imagePaths: imagePaths ?? this.imagePaths,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      isComment: isComment ?? this.isComment,
    );
  }

  static PostModel fromEntity(PostEntity entity) {
    return PostModel(
      id: entity.id,
      ownerId: entity.ownerId ?? '',
      content: entity.content ?? '',
      imagePaths: entity.imagePaths ?? [],
      imageUrls: entity.imageUrls ?? [],
      likes: entity.likes ?? [],
      commentIds: entity.commentIds ?? [],
      isComment: entity.isComment ?? false,
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      ownerId: ownerId,
      content: content,
      imagePaths: imagePaths,
      imageUrls: imageUrls,
      likes: likes,
      commentIds: commentIds,
      isComment: isComment,
    );
  }
}