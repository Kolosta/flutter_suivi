import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final int commentCount;
  final VoidCallback onComment;
  final double iconSize;
  final double textSize;

  const Comment({
    super.key,
    required this.onComment,
    required this.commentCount,
    this.iconSize = 24.0,
    this.textSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IconButton(
        onPressed: onComment,
        icon: const Icon(Icons.comment),
        iconSize: iconSize,
        tooltip: "Comment",
      ),
      Text('$commentCount', style: TextStyle(fontSize: textSize)),
    ]);
  }
}