import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/base_64_to_file.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/main/post_bloc.dart';
import '../pages/post_detail_page.dart';
import 'post_images_widget.dart';

class PostWidget extends StatelessWidget {
  final PostEntity post;
  final String userId;
  final PostBloc postBloc;

  const PostWidget({super.key, required this.post, required this.userId, required this.postBloc});



  @override
  Widget build(BuildContext context) {
    // Dispatch the event to fetch user details
    postBloc.add(FetchPostUserDetailsEvent(post.id));

    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update like: ${state.message}')),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(
                postId: post.id,
                userId: userId,
                postBloc: postBloc,
              ),
            ),
          );
        },
        child: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    final user = post.owner;
                    return Row(
                      children: [
                        FutureBuilder<File>(
                          key: ValueKey(user?.userId), // Ensure unique key for each user
                          future: user?.profileImage != null ? base64ToFile(user!.profileImage!, 'profile_image_${user.userId}.png') : null,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundImage: FileImage(snapshot.data!),
                              );
                            } else {
                              return const CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey,
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          user?.username ?? 'Unknown',
                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                if (!post.isComment)
                  PostImagesWidget(
                    imagePaths: post.imagePaths ?? [],
                    imageUrls: post.imageUrls ?? [],
                  ),
                const SizedBox(height: 8.0),
                Text(
                  post.content ?? '',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        (post.likes?.contains(userId) ?? false) ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 16.0,
                      ),
                      onPressed: () {
                        postBloc.add(ToggleLikeEvent(post, userId));
                      },
                    ),
                    const SizedBox(width: 4.0),
                    Text('${post.likes?.length ?? 0}'),
                    if (!post.isComment) ...[
                      const SizedBox(width: 16.0),
                      IconButton(
                        icon: const Icon(Icons.comment, size: 16.0),
                        onPressed: () {
                          // Rien pour le moment... n'importe où sur le widget permet  d'afficher les commentaires
                        },
                      ),
                      const SizedBox(width: 4.0),
                      Text('${post.commentIds?.length ?? 0}'),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}