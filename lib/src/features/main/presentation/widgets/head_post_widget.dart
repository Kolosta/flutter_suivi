import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/models/delete_post_model.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/main/post_bloc.dart';
import '../pages/write_comment_page.dart';
import 'post_images_widget.dart';

class HeadPostWidget extends StatelessWidget {
  final PostEntity post;
  final String userId;
  final PostDetailBloc postDetailBloc;
  final PostBloc postBloc;

  const HeadPostWidget({super.key, required this.post, required this.userId, required this.postBloc, required this.postDetailBloc});


  void _openAddCommentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: postDetailBloc,
          child: WriteCommentPage(
            user: UserEntity(userId: userId),
            post: post,
            postDetailBloc: postDetailBloc,
            postBloc: postBloc,
          ),
        ),
      ),
    );
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("delete_comment".tr()),
          content: Text('confirm_comment_deletion'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                final deletePostModel = DeletePostModel(id: post.id, isComment: post.isComment);
                postDetailBloc.add(DeleteCommentEvent(deletePostModel, postBloc));
                Navigator.of(context).pop();
                if (!post.isComment) {
                  Navigator.of(context).pop();
                }
              },
              child: Text('delete'.tr()),
            ),
          ],
        );
      },
    );
  }

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
                        // Do nothing here
                      },
                    ),
                    const SizedBox(width: 4.0),
                    Text('${post.commentIds?.length ?? 0}'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 16.0),
                      onPressed: () {
                        _confirmDeletion(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.reply, size: 16.0),
                      onPressed: () => _openAddCommentPage(context),
                    ),
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