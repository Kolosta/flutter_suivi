import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/detail/detail_bloc.dart';
import '../bloc/main/post_bloc.dart';
import '../widgets/comment_widget.dart';
import '../widgets/head_post_widget.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;
  final String userId;
  final PostBloc postBloc;

  const PostDetailPage({
    super.key,
    required this.postId,
    required this.userId,
    required this.postBloc,
  });

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late PostDetailBloc _postDetailBloc;

  @override
  void initState() {
    super.initState();
    _postDetailBloc = getIt<PostDetailBloc>()..add(LoadPostDetailEvent(widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.postBloc),
        BlocProvider.value(value: _postDetailBloc),
      ],
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
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, postState) {
            if (postState is PostSuccessState) {
              final post = postState.data.firstWhere((post) => post.id == widget.postId);
              return BlocBuilder<PostDetailBloc, PostDetailState>(
                builder: (context, state) {
                  if (state is PostDetailInitialState) {
                    logger.i('PostDetailInitialState CommentPage');
                    return const Center(child: Text('Loading comments...'));
                  } else if (state is PostDetailLoadingState) {
                    logger.i('PostDetailLoadingState CommentPage');
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PostDetailSuccessState) {
                    logger.i('PostDetailSuccessState CommentPage avec ${state.comments.length} commentaires');
                    final comments = state.comments;
                    return Column(
                      children: [
                        Column(
                          children: [
                            HeadPostWidget(
                              post: post,
                              userId: widget.userId,
                              postBloc: widget.postBloc,
                              postDetailBloc: _postDetailBloc,
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
                                  userId: widget.userId,
                                  postDetailBloc: _postDetailBloc,
                                  postBloc: widget.postBloc,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    logger.i('State inconnu/failure CommentPage. Failed to load comments. State : $state');
                    return const Center(child: Text('Failed to load comments'));
                  }
                },
              );
            } else {
              return const Center(child: Text('Failed to load post'));
            }
          },
        ),
      ),
    );
  }
}