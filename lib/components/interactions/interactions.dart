import 'package:flutter/material.dart';
import 'package:tp1_flutter/components/interactions/comment.dart';
import 'package:tp1_flutter/components/interactions/like.dart';
import 'package:tp1_flutter/components/interactions/share.dart';

class Interactions extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final int shareCount;

  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final bool isLiked;
  final bool isComment;

  const Interactions({
    super.key,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.isLiked,
    this.isComment = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isComment ? 20.0 : 24.0;
    final textSize = isComment ? 12.0 : 14.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Like(
          onLike: onLike,
          likeCount: likeCount,
          isLiked: isLiked,
          iconSize: iconSize,
          textSize: textSize,
        ),
        Comment(
          onComment: onComment,
          commentCount: commentCount,
          iconSize: iconSize,
          textSize: textSize,
        ),
        Share(
          onShare: onShare,
          shareCount: shareCount,
          iconSize: iconSize,
          textSize: textSize,
        ),
      ],
    );
  }
}