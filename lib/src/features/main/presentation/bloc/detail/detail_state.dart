part of 'detail_bloc.dart';

abstract class PostDetailState extends Equatable {
  const PostDetailState();

  @override
  List<Object> get props => [];
}

class PostDetailInitialState extends PostDetailState {}

class PostDetailLoadingState extends PostDetailState {}

// class PostDetailSuccessState extends PostDetailState {
//   final PostEntity activePost;
//   final List<PostEntity> comments;
//
//   const PostDetailSuccessState(this.activePost, this.comments);
//
//   @override
//   List<Object> get props => [activePost, comments];
// }
class PostDetailSuccessState extends PostDetailState {
  final String activePostId;
  final List<PostEntity> comments;

  const PostDetailSuccessState(this.activePostId, this.comments);

  @override
  List<Object> get props => [activePostId, comments];
}

class PostDetailFailureState extends PostDetailState {
  final String message;

  const PostDetailFailureState(this.message);

  @override
  List<Object> get props => [message];
}
