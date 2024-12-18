import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/post_bloc.dart';
import '../pages/comments_page.dart';
import 'post_images_widget.dart';

class PostWidget extends StatelessWidget {
  final PostEntity post;
  final String userId;

  const PostWidget({super.key, required this.post, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update like: ${state.message}')),
          );
        }
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      context.read<PostBloc>().add(ToggleLikeEvent(post, userId));
                    },
                  ),
                  const SizedBox(width: 4.0),
                  Text('${post.likes?.length ?? 0}'),
                  if (!post.isComment) ...[
                    const SizedBox(width: 16.0),
                    IconButton(
                      icon: const Icon(Icons.comment, size: 16.0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsPage(
                              post: post,
                              userId: userId,
                            ),
                          ),
                        );
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
    );
  }
}