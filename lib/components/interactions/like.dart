import 'package:flutter/material.dart';

class Like extends StatelessWidget {
  final int likeCount;
  final VoidCallback onLike;
  final bool isLiked;
  final double iconSize;
  final double textSize;

  const Like({
    super.key,
    required this.onLike,
    required this.likeCount,
    required this.isLiked,
    this.iconSize = 24.0,
    this.textSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IconButton(
        onPressed: onLike,
        icon: Icon(isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt),
        iconSize: iconSize,
        tooltip: "Like",
      ),
      Text('$likeCount', style: TextStyle(fontSize: textSize)),
    ]);
  }
}