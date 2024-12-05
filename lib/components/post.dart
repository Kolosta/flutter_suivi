import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1_flutter/components/interactions/interactions.dart';
import 'package:tp1_flutter/components/miniprofile.dart';
import 'package:tp1_flutter/components/shared_post.dart';
import 'package:tp1_flutter/models/post.dart' as models;
import 'package:tp1_flutter/providers/post_provider.dart';
import 'package:tp1_flutter/providers/user_provider.dart';

import '../pages/add_comment_page.dart';

class Post extends StatelessWidget {
  final models.Post post;
  final int shareCount;
  final bool isComment;

  const Post({super.key, required this.post, this.shareCount = 0, this.isComment = false});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    final isLiked = currentUser != null && post.likes.contains(currentUser);

    Widget postContent = Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Profile Picture + Username)
          MiniProfile(user: post.owner),
          if (isComment) ...[
            Text(
              'En réponse à ${post.owner.username}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
          if (post.content != null) ...[
            const SizedBox(height: 10),
            // Text Content
            Text(
              post.content!,
              style: const TextStyle(fontSize: 14),
            ),
          ],
          if (post.image != null) ...[
            const SizedBox(height: 10),
            // Optional Post Image
            GestureDetector(
              onTap: () => _showFullScreenImage(context, post.image!),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/default_image.jpg');
                    },
                  ),
                ),
              ),
            ),
          ],
          // Shared Post
          if (post.embededPost != null) ...[
            const SizedBox(height: 10),
            SharedPost(post: post.embededPost!),
          ],
          const SizedBox(height: 10),
          // Action Buttons (Like, Share, Comment)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Interactions(
                likeCount: post.likes.length,
                commentCount: post.comments.fold(0, _getNbComments),
                shareCount: shareCount,
                onLike: () => onLike(context),
                onComment: () => onComment(context),
                onShare: onShare,
                isLiked: isLiked,
                isComment: isComment,
              ),
              ...post.comments.map((comment) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.grey[400]!, width: 1),
                            ),
                          ),
                          child: Post(post: comment, isComment: true)
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );

    if (isComment) {
      postContent = Row(
        children: [
          Container(
            width: 2,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(child: postContent),
        ],
      );
    }

    return postContent;
  }

  void onLike(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      postProvider.likePost(post, userProvider.currentUser!);
    }
  }

  void onComment(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddCommentPage(post: post),
        ),
      );
    }
  }

  void onShare() {}

  int _getNbComments(int value, models.Post aPost) {
    return aPost.comments.fold(value, _getNbComments) + 1;
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black54,
          child: Stack(
            children: [
              Center(
                child: Image.network(imageUrl),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}