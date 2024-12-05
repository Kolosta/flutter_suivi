import 'package:flutter/material.dart';

class Share extends StatelessWidget {
  final int shareCount;
  final VoidCallback onShare;
  final double iconSize;
  final double textSize;

  const Share({
    super.key,
    required this.onShare,
    required this.shareCount,
    this.iconSize = 24.0,
    this.textSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IconButton(
        onPressed: onShare,
        icon: const Icon(Icons.share),
        iconSize: iconSize,
        tooltip: "Share",
      ),
      Text('$shareCount', style: TextStyle(fontSize: textSize)),
    ]);
  }
}