import 'package:flutter/material.dart';
import 'dart:io';

class PostImagesWidget extends StatelessWidget {
  final List<String> imagePaths;
  final List<String> imageUrls;

  const PostImagesWidget({
    super.key,
    required this.imagePaths,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    final images = [
      ...imagePaths.map((path) => Image.file(File(path))).toList(),
      ...imageUrls.map((url) => Image.network(url)).toList(),
    ].take(4).toList();

    if (images.isEmpty) return Container();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: _buildImageLayout(images),
        ),
      ),
    );
  }

  Widget _buildImageLayout(List<Widget> images) {
    switch (images.length) {
      case 1:
        return Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: images[0],
          ),
        );
      case 2:
        return Row(
          children: [
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: images[0],
                ),
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: images[1],
                ),
              ),
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: images[0],
                ),
              ),
            ),
            const SizedBox(width: 4.0),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: images[1],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: images[2],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: images[0],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: images[1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: images[2],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: images[3],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}