part of 'detail_bloc.dart';

abstract class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadPostDetailEvent extends PostDetailEvent {
  final String postId;
  final PostEntity post;

  const LoadPostDetailEvent(this.postId, this.post);

  @override
  List<Object> get props => [postId, post];
}

class DeleteCommentEvent extends PostDetailEvent {
  final DeletePostModel postModel;
  final PostBloc postBloc;

  const DeleteCommentEvent(this.postModel, this.postBloc);

  @override
  List<Object> get props => [postModel];
}

class ToggleLikeOnPostEvent extends PostDetailEvent {
  final String userId;
  final PostEntity post;

  const ToggleLikeOnPostEvent(this.userId, this.post);

  @override
  List<Object> get props => [userId, post];
}

class AddCommentEvent extends PostDetailEvent {
  final PostEntity post;
  final PostEntity comment;
  final PostBloc postBloc;

  const AddCommentEvent(this.post, this.comment, this.postBloc);

  @override
  List<Object> get props => [post, comment];
}

