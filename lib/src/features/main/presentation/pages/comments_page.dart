import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/post_bloc.dart';
import '../widgets/post_widget.dart';
import '../widgets/comment_widget.dart';

// class CommentsPage extends StatefulWidget {
//   final PostEntity post;
//   final String userId;
//
//   const CommentsPage({
//     super.key,
//     required this.post,
//     required this.userId
//   });
//
//   @override
//   _CommentsPageState createState() => _CommentsPageState();
// }

class CommentsPage extends StatelessWidget {
  final PostEntity post;
  final String userId;
  final PostBloc postBloc;

  const CommentsPage({
    super.key,
    required this.post,
    required this.userId,
    required this.postBloc
  });


// class _CommentsPageState extends State<CommentsPage> {
//   late final PostBloc _postBloc;

  // @override
  // void initState() {
  //   super.initState();
  //   _postBloc = getIt<PostBloc>()..add(GetCommentsEvent(widget.post.id));
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: postBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Comments'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostSuccessState) {
              // setState(() {});
              logger.i('PostSuccessState détecté, interface mise à jour.');
            }
          },
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostLoadingState) {
                logger.i('PostLoadingState CommentPage');
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostSuccessState) {
                logger.i('PostSuccessState CommentPage avec ${state.data.length} commentaires');
                final comments = state.data.where((post) => post.commentIds?.contains(post.id) ?? false).toList();
                return Column(
                  children: [
                    Column(
                      children: [
                        CommentWidget(
                            comment: post,
                            userId: userId,
                            postBloc: postBloc
                        ),
                        const Divider(),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return Container(
                              margin: const EdgeInsets.only(bottom: 4.0),
                              child: CommentWidget(
                                  comment: comment,
                                  userId: userId,
                                  postBloc: postBloc
                              )
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                logger.i('State inconnu/failure CommentPage. Failed to load comments');
                return const Center(child: Text('Failed to load comments'));
              }
            },
          ),
        ),
      ),
    );
  }
}