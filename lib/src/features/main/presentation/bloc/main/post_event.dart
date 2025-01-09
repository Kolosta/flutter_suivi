part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends PostEvent {
  const GetPostsEvent();

  @override
  List<Object> get props => [];
}

class GetPostsByIdsEvent extends PostEvent {
  final List<String> ids;

  const GetPostsByIdsEvent(this.ids);

  @override
  List<Object> get props => [ids];
}

class AddPostEvent extends PostEvent {
  final PostEntity post;

  const AddPostEvent(this.post);

  @override
  List<Object> get props => [post];
}

class DeletePostEvent extends PostEvent {
  final DeletePostModel postModel;

  const DeletePostEvent(this.postModel);

  @override
  List<Object> get props => [postModel];
}

class ToggleLikeEvent extends PostEvent {
  final PostEntity post;
  final String userId;

  const ToggleLikeEvent(this.post, this.userId);

  @override
  List<Object> get props => [post, userId];
}

class GetCommentsEvent extends PostEvent {
  final String postId;

  const GetCommentsEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

// class AddCommentEvent extends PostEvent {
//   final PostEntity post;
//   final PostEntity comment;
//
//   const AddCommentEvent(this.post, this.comment);
//
//   @override
//   List<Object> get props => [post, comment];
// }

class SetActivePostEvent extends PostEvent {
  final PostEntity post;

  const SetActivePostEvent(this.post);

  @override
  List<Object> get props => [post];
}

class LoadCommentsEvent extends PostEvent {
  final String postId;

  const LoadCommentsEvent(this.postId);

  @override
  List<Object> get props => [postId];
}

class UpdatePostCommentCountEvent extends PostEvent {
  final String postToUpdateId;
  final String postAddedId;

  const UpdatePostCommentCountEvent(this.postToUpdateId, this.postAddedId);

  @override
  List<Object> get props => [postToUpdateId, postAddedId];
}

class RemovePostCommentIdEvent extends PostEvent {
  final String postToUpdateId;
  final String commentIdToRemove;

  const RemovePostCommentIdEvent(this.postToUpdateId, this.commentIdToRemove);

  @override
  List<Object> get props => [postToUpdateId, commentIdToRemove];
}