import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp1_flutter/src/features/main/domain/usecases/get_comments_usecase.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../../../core/utils/failure_converter.dart';
import '../../../../../core/utils/logger.dart';
import '../../../data/models/delete_post_model.dart';
import '../../../data/models/toggle_like_model.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/usecases/add_comment_usecase.dart';
import '../../../domain/usecases/add_post_usecase.dart';
import '../../../domain/usecases/delete_post_usecase.dart';
import '../../../domain/usecases/get_posts_by_ids_usecase.dart';
import '../../../domain/usecases/get_posts_usecase.dart';
import '../../../domain/usecases/toggle_like_usecase.dart';

part 'post_event.dart';
part 'post_state.dart';


class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase repository;
  final GetPostsByIdsUseCase getPostsByIdsUseCase;
  final AddPostUseCase addPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final ToggleLikeUsecase toggleLikeUsecase;
  final GetCommentsUseCase getCommentsUseCase;
  final AddCommentUseCase addCommentUseCase;

  PostBloc(
      this.repository,
      this.getPostsByIdsUseCase,
      this.addPostUseCase,
      this.deletePostUseCase,
      this.toggleLikeUsecase,
      this.getCommentsUseCase,
      this.addCommentUseCase,
  ) : super(PostInitialState()){
    on<GetPostsEvent>(_getPosts);
    on<GetPostsByIdsEvent>(_getPostsByIds);
    on<AddPostEvent>(_addPost);
    on<DeletePostEvent>(_deletePost);
    on<ToggleLikeEvent>(_toggleLike);
    on<GetCommentsEvent>(_getComments);
    // on<AddCommentEvent>(_addComment);
    on<SetActivePostEvent>(_setActivePost);
    on<LoadCommentsEvent>(_loadComments);
  }

  @override
  void onTransition(Transition<PostEvent, PostState> transition) {
    super.onTransition(transition);
    logger.i('Transition from ${transition.currentState} to ${transition.nextState} on ${transition.event}');
  }


  Future<void> _getPosts(GetPostsEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());

    final result = await repository.call(NoParams());

    result.fold(
      (failure) => emit(PostFailureState(mapFailureToMessage(failure))),
      (posts) => emit(PostSuccessState(posts)),
    );
  }

  Future<void> _getPostsByIds(GetPostsByIdsEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());

    final result = await getPostsByIdsUseCase.call(event.ids);

    result.fold(
          (failure) => emit(PostFailureState(mapFailureToMessage(failure))),
          (posts) => emit(PostSuccessState(posts)),
    );
  }

  // Future<void> _addPost(AddPostEvent event, Emitter<PostState> emit) async {
  //   emit(PostLoadingState());
  //
  //   final result = await addPostUseCase.call(event.post);
  //
  //   result.fold(
  //         (failure) => emit(PostFailureState(mapFailureToMessage(failure))),
  //         (_) => add(const GetPostsEvent()),
  //   );
  // }
  Future<void> _addPost(AddPostEvent event, Emitter<PostState> emit) async {
    final currentState = state;
    logger.i("_addPost called. State : $currentState");

    if (currentState is PostSuccessState) {
      // Émettre l'état de chargement
      emit(PostLoadingState());

      // Ajouter le post de manière optimiste
      final updatedPosts = List<PostEntity>.from(currentState.data)..add(event.post);
      emit(PostSuccessState(updatedPosts));

      // Ajouter le post dans Firebase
      final result = await addPostUseCase.call(event.post);

      result.fold(
        (failure) {
          // Rétablir l'état précédent en cas d'échec
          emit(PostFailureState(mapFailureToMessage(failure)));
          emit(PostSuccessState(currentState.data));
        },
            (_) {
          // Ne rien faire, la mise à jour optimiste est déjà appliquée
        },
      );
    }
  }

  // Future<void> _deletePost(DeletePostEvent event, Emitter<PostState> emit) async {
  //   emit(PostLoadingState());
  //
  //   final result = await deletePostUseCase.call(event.postModel);
  //
  //   result.fold(
  //         (failure) => emit(PostFailureState(mapFailureToMessage(failure))),
  //         (_) => add(const GetPostsEvent()),
  //   );
  // }
  Future<void> _deletePost(DeletePostEvent event, Emitter<PostState> emit) async {
    // Émettre une mise à jour optimiste
    final currentState = state;
    if (currentState is PostSuccessState) {
      final updatedPosts = currentState.data.where((post) => post.id != event.postModel.id).toList();
      emit(PostSuccessState(updatedPosts));
    }

    final result = await deletePostUseCase.call(event.postModel);

    result.fold(
      (failure) {
        // Recharger les posts en cas d'échec
        emit(PostFailureState(mapFailureToMessage(failure)));
        add(const GetPostsEvent());
      },
      (_) {
        // Ne rien faire, la mise à jour optimiste est déjà appliquée
      },
    );
  }

  Future<void> _getComments(GetCommentsEvent event, Emitter<PostState> emit) async {
    emit(PostLoadingState());

    final result = await getCommentsUseCase.call(event.postId);

    logger.i("_getComments called");

    result.fold(
          (failure) => emit(PostFailureState(mapFailureToMessage(failure))),
          (comments) => emit(PostSuccessState(comments)),
    );
  }


  // Future<void> _addComment(AddCommentEvent event, Emitter<PostState> emit) async {
  //   final currentState = state;
  //   logger.i("_addComment called. State : $currentState");
  //   emit(PostLoadingState());
  //
  //
  //   final result = await addCommentUseCase.call(AddCommentParams(event.post.id, event.comment));
  //
  //   result.fold(
  //         (failure) => emit(PostFailureState(mapFailureToMessage(failure))),
  //         (_) => add(GetCommentsEvent(event.post.id)), // Recharger les commentaires
  //   );
  // }
    // final currentState = state;
    // if (currentState is PostSuccessState) {
    //   // Émettre l'état de chargement
    //   emit(PostLoadingState());
    //
    //   // Ajouter le post de manière optimiste
    //   final updatedPosts = List<PostEntity>.from(currentState.data)..add(event.post);
    //   emit(PostSuccessState(updatedPosts));
    //
    //   // Ajouter le post dans Firebase
    //   final result = await addPostUseCase.call(event.post);
    //
    //   result.fold(
    //         (failure) {
    //       // Rétablir l'état précédent en cas d'échec
    //       emit(PostFailureState(mapFailureToMessage(failure)));
    //       emit(PostSuccessState(currentState.data));
    //     },
    //         (_) {
    //       // Ne rien faire, la mise à jour optimiste est déjà appliquée
    //     },
    //   );
    // }
  // Future<void> _addComment(AddCommentEvent event, Emitter<PostState> emit) async {
  //   // Check if the current state is PostSuccessState
  //   final currentState = state;
  //   if (currentState is PostSuccessState) {
  //     // Récupérer les commentaires actuels, et ajouter le nouveau commentaire
  //     final List<PostEntity> updatedComments = List<PostEntity>.from(currentState.data)..add(event.comment);
  //     emit(PostSuccessState(updatedComments));
  //
  //     // Récupérer le post actuel, et ajouter le nouveau commentaire id dans la liste des commentaires ids
  //     final updatedPost = event.post.copyWith(commentIds: List<String>.from(event.post.commentIds ?? [])..add(event.comment.id));
  //
  //     // Émettre l'état de succès avec la liste des commentaires mise à jour
  //     emit(PostSuccessState(currentState.data.map((post) {
  //       return post.id == event.post.id ? updatedPost : post;
  //     }).toList()));
  //
  //     // Ajouter le commentaire dans la base de données
  //     final result = await addCommentUseCase.call(AddCommentParams(event.post.id, event.comment));
  //
  //     result.fold(
  //       (failure) => emit(PostFailureState(mapFailureToMessage(failure))),
  //       (_) {
  //         // Recharger les commentaires
  //         logger.e("GetCommentsEvent emis dans le addComment");
  //         add(GetCommentsEvent(event.post.id));
  //       },
  //     );
  //   } else {
  //     logger.e("Mauvais state. State actuel : $currentState");
  //   }
  // }


  Future<void> _toggleLike(ToggleLikeEvent event, Emitter<PostState> emit) async {
    final updatedPost = event.post.copyWith(
      likes: (event.post.likes?.contains(event.userId) ?? false)
          ? (List.from(event.post.likes ?? [])..remove(event.userId))
          : (List.from(event.post.likes ?? [])..add(event.userId)),
    );

    // Emit an optimistic update
    emit(PostSuccessState(
      (state as PostSuccessState).data.map((post) {
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
        emit(PostFailureState(mapFailureToMessage(failure)));
        emit(PostSuccessState(
          (state as PostSuccessState).data.map((post) {
            return post.id == event.post.id ? event.post : post;
          }).toList(),
        ));
      },
          (_) {
        // Do nothing, the optimistic update will be replaced by the real data
        }
    );
  }


  Future<void> _setActivePost(SetActivePostEvent event, Emitter<PostState> emit) async {
    emit(PostActiveState(event.post, []));
    add(LoadCommentsEvent(event.post.id));
  }

  Future<void> _loadComments(LoadCommentsEvent event, Emitter<PostState> emit) async {
    if (state is PostActiveState) {
      final result = await getCommentsUseCase.call(event.postId);

      result.fold(
            (failure) => emit(PostFailureState(mapFailureToMessage(failure))),
            (comments) => emit(PostActiveState((state as PostActiveState).activePost, comments)),
      );
    }
  }

}