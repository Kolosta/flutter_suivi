import 'package:tp1_flutter/src/features/main/domain/entities/post_entity.dart';

class ToggleLikeModel extends PostEntity {
  final String postId;
  final String userId;

  ToggleLikeModel({
    required this.postId,
    required this.userId,
  }) : super(
          id: postId,
          ownerId: userId,
          content: '',
          imagePaths: [],
          imageUrls: [],
          likes: [],
          commentIds: [],
        );

  // ToggleLikeModel copyWith({String? postId, String? userId}) {
  //   return ToggleLikeModel(
  //     postId: postId ?? (this.postId),
  //     userId: userId ?? (this.userId),
  //   );
  // }
}