import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/base_64_to_file.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../data/models/delete_post_model.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/main/post_bloc.dart';
import '../pages/write_comment_page.dart';
import 'post_images_widget.dart';

class CommentWidget extends StatelessWidget {
  final PostEntity comment;
  final String userId;
  final PostDetailBloc postDetailBloc;
  final PostBloc postBloc;

  const CommentWidget({super.key, required this.comment, required this.userId, required this.postDetailBloc, required this.postBloc});

  void _openAddCommentPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: postDetailBloc,
          child: WriteCommentPage(
            user: UserEntity(userId: userId),
            post: comment,
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
                final deletePostModel = DeletePostModel(id: comment.id, isComment: comment.isComment);
                postDetailBloc.add(DeleteCommentEvent(deletePostModel, postBloc));
                Navigator.of(context).pop();
                if (!comment.isComment) {
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
    postDetailBloc.add(FetchDetailPostUserDetailsEvent(comment.id));

    return BlocListener<PostDetailBloc, PostDetailState>(
      listener: (context, state) {
        if (state is PostDetailFailureState) {
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
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  final user = comment.owner;
                  return Row(
                    children: [
                      FutureBuilder<File>(
                        key: ValueKey(user?.userId),
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
              PostImagesWidget(
                imagePaths: comment.imagePaths ?? [],
                imageUrls: comment.imageUrls ?? [],
              ),
              const SizedBox(height: 8.0),
              Text(
                comment.content ?? '',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      (comment.likes?.contains(userId) ?? false) ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 16.0,
                    ),
                    onPressed: () {
                      postDetailBloc.add(ToggleLikeOnPostEvent(userId, comment));
                    },
                  ),
                  const SizedBox(width: 4.0),
                  Text('${comment.likes?.length ?? 0}'),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

