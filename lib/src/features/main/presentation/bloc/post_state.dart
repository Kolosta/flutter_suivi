part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostSuccessState extends PostState {
  final List<PostEntity> data;

  const PostSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class PostFailureState extends PostState {
  final String message;

  const PostFailureState(this.message);

  @override
  List<Object> get props => [message];
}