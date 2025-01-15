import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp1_flutter/src/features/main/domain/usecases/get_comments_usecase.dart';

import '../../../../../core/utils/failure_converter.dart';
import '../../../../../core/utils/logger.dart';
import '../../../data/models/delete_post_model.dart';
import '../../../data/models/toggle_like_model.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecases/add_comment_usecase.dart';
import '../../../domain/usecases/delete_post_usecase.dart';
import '../../../domain/usecases/toggle_like_usecase.dart';
import '../main/post_bloc.dart';

part 'detail_event.dart';
part 'detail_state.dart';


class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final GetCommentsUseCase getCommentsUseCase;
  final ToggleLikeUsecase toggleLikeUsecase;
  final AddCommentUseCase addCommentUseCase;
  final DeletePostUseCase deletePostUseCase;
  // final PostBloc postBloc;

  PostDetailBloc(
      this.getCommentsUseCase,
      this.toggleLikeUsecase,
      this.addCommentUseCase,
      this.deletePostUseCase,
      // this.postBloc
  )
      : super(PostDetailInitialState()) {
    on<LoadPostDetailEvent>(_loadPostDetail);
    on<ToggleLikeOnPostEvent>(_toggleLikeOnPost);
    on<AddCommentEvent>(_addComment);
    on<DeleteCommentEvent>(_deleteComment);
  }

  // Future<void> _loadPostDetail(LoadPostDetailEvent event, Emitter<PostDetailState> emit) async {
  //   emit(PostDetailLoadingState());
  //
  //   final result = await getCommentsUseCase.call(event.postId);
  //
  //   result.fold(
  //         (failure) => emit(PostDetailFailureState(mapFailureToMessage(failure))),
  //         (comments) => emit(PostDetailSuccessState(event.post, comments)),
  //   );
  // }
  Future<void> _loadPostDetail(LoadPostDetailEvent event, Emitter<PostDetailState> emit) async {
    emit(PostDetailLoadingState());

    final result = await getCommentsUseCase.call(event.activePostId);

    result.fold(
      (failure) => emit(PostDetailFailureState(mapFailureToMessage(failure))),
      (comments) => emit(PostDetailSuccessState(event.activePostId, comments)),
    );
  }

  Future<void> _deleteComment(DeleteCommentEvent event, Emitter<PostDetailState> emit) async {
    // Émettre une mise à jour optimiste
    final currentState = state;
    if (currentState is PostDetailSuccessState) {
      final updatedPosts = currentState.comments.where((post) => post.id != event.postModel.id).toList();
      emit(PostDetailSuccessState(currentState.activePostId, updatedPosts));
      event.postBloc.add(RemovePostCommentIdEvent(currentState.activePostId, event.postModel.id));
    }

    final result = await deletePostUseCase.call(event.postModel);

    result.fold(
          (failure) {
        // Recharger les posts en cas d'échec
        emit(PostDetailFailureState(mapFailureToMessage(failure)));
        // add(const GetPostsEvent());
      },
          (_) {
        // Ne rien faire, la mise à jour optimiste est déjà appliquée
      },
    );
  }

  Future<void> _toggleLikeOnPost(ToggleLikeOnPostEvent event, Emitter<PostDetailState> emit) async {
    final updatedPost = event.post.copyWith(
      likes: (event.post.likes?.contains(event.userId) ?? false)
          ? (List.from(event.post.likes ?? [])..remove(event.userId))
          : (List.from(event.post.likes ?? [])..add(event.userId)),
    );

    // Emit an optimistic update
    emit(PostDetailSuccessState(
      (state as PostDetailSuccessState).activePostId,
      (state as PostDetailSuccessState).comments.map((post) {
        return post.id == event.post.id ? updatedPost : post;
      }).toList(),
    ));

    final model = ToggleLikeModel(
      postId: event.post.id,
      userId: event.userId,
    );

    final result = await toggleLikeUsecase.call(model);

    result.fold(
            (failure) {
          // Revert the optimistic update if the call fails
              emit(PostDetailFailureState(mapFailureToMessage(failure)));
              emit(PostDetailSuccessState(
                (state as PostDetailSuccessState).activePostId,
                (state as PostDetailSuccessState).comments.map((post) {
                  return post.id == event.post.id ? event.post : post;
                }).toList(),
              ));
        },
            (_) {
          // Do nothing, the optimistic update will be replaced by the real data
        }
    );
  }

  Future<void> _addComment(AddCommentEvent event, Emitter<PostDetailState> emit) async {
    final currentState = state;
    logger.i("_addComment called. State : $currentState");
    emit(PostDetailLoadingState());


    final result = await addCommentUseCase.call(AddCommentParams(event.post.id, event.comment));

    // result.fold(
    //       (failure) => emit(PostDetailFailureState(mapFailureToMessage(failure))),
    //       (_) => emit(PostDetailSuccessState(event.post, (state as PostDetailSuccessState).comments)),
    // );
    result.fold(
          (failure) => emit(PostDetailFailureState(mapFailureToMessage(failure))),
          (_) {
        if (currentState is PostDetailSuccessState) {
          final updatedComments = List<PostEntity>.from(currentState.comments)..add(event.comment);
          emit(PostDetailSuccessState(event.post.id, updatedComments));
          event.postBloc.add(UpdatePostCommentCountEvent(event.post.id, event.comment.id));
        }
      },
    );
  }


}
