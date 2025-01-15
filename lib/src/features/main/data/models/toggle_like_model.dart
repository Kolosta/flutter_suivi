import 'package:tp1_flutter/src/features/main/domain/entities/post_entity.dart';

import '../../domain/entities/post_user_entity.dart';

class ToggleLikeModel extends PostEntity {
  final String postId;
  final String userId;

  ToggleLikeModel({
    required this.postId,
    required this.userId,
  }) : super(
          id: postId,
          owner: PostUserEntity(userId: userId),
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