// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/utils/logger.dart';
// import '../../domain/entities/post_entity.dart';
// import '../bloc/main/post_bloc.dart';
// import '../widgets/comment_widget.dart';
//
// class PostDetailPage extends StatelessWidget {
//   final PostEntity post;
//   final String userId;
//   final PostBloc postBloc;
//
//   const PostDetailPage({
//     super.key,
//     required this.post,
//     required this.userId,
//     required this.postBloc,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: postBloc..add(SetActivePostEvent(post)),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Comments'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         body: BlocBuilder<PostBloc, PostState>(
//           builder: (context, state) {
//             if (state is PostLoadingState) {
//               logger.i('PostLoadingState CommentPage');
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is PostActiveState) {
//               logger.i('PostActiveState CommentPage avec ${state.comments.length} commentaires');
//               final comments = state.comments;
//               return Column(
//                 children: [
//                   Column(
//                     children: [
//                       CommentWidget(
//                         comment: state.activePost,
//                         userId: userId,
//                         postBloc: postBloc,
//                       ),
//                       const Divider(),
//                     ],
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: comments.length,
//                       itemBuilder: (context, index) {
//                         final comment = comments[index];
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 4.0),
//                           child: CommentWidget(
//                             comment: comment,
//                             userId: userId,
//                             postBloc: postBloc,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               logger.i('State inconnu/failure CommentPage. Failed to load comments. State : $state');
//               return const Center(child: Text('Failed to load comments'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/detail/detail_bloc.dart';
import '../widgets/comment_widget.dart';

class PostDetailPage extends StatefulWidget {
  final PostEntity post;
  final String userId;

  const PostDetailPage({
    super.key,
    required this.post,
    required this.userId,
  });

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late PostDetailBloc _postDetailBloc;

  @override
  void initState() {
    super.initState();
    _postDetailBloc = getIt<PostDetailBloc>()..add(LoadPostDetailEvent(widget.post.id, widget.post));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _postDetailBloc,
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
        body: BlocBuilder<PostDetailBloc, PostDetailState>(
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
                      CommentWidget(
                        comment: state.activePost,
                        userId: widget.userId,
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
        ),
      ),
    );
  }
}