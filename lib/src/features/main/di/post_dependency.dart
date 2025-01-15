import 'package:tp1_flutter/src/configs/injector/injector.dart';
import 'package:tp1_flutter/src/features/main/domain/usecases/delete_post_usecase.dart';
import 'package:tp1_flutter/src/features/main/domain/usecases/get_posts_usecase.dart';
import 'package:tp1_flutter/src/features/main/domain/usecases/toggle_like_usecase.dart';
import 'package:tp1_flutter/src/features/main/presentation/bloc/main/post_bloc.dart';

import '../../../configs/injector/injector_conf.dart';
import '../data/datasources/post_remote_data_source.dart';
import '../data/repositories/post_repository_impl.dart';
import '../domain/usecases/add_comment_usecase.dart';
import '../domain/usecases/add_post_usecase.dart';
import '../domain/usecases/fetch_user_details_usecase.dart';
import '../domain/usecases/get_comments_usecase.dart';
import '../domain/usecases/get_posts_by_ids_usecase.dart';
import '../presentation/bloc/detail/detail_bloc.dart';

class PostDependency{
  PostDependency._();

  static void init(){
    // Bloc
    getIt.registerFactory(
      () => PostBloc(
          getIt<GetPostsUseCase>(),
          getIt<GetPostsByIdsUseCase>(),
          getIt<AddPostUseCase>(),
          getIt<DeletePostUseCase>(),
          getIt<ToggleLikeUsecase>(),
          getIt<GetCommentsUseCase>(),
          getIt<AddCommentUseCase>(),
          getIt<FetchUserDetailsUseCase>(),
          // getIt<RemovePostCommentIdEvent>(),
      ),
    );
    getIt.registerFactory(
      () => PostDetailBloc(
          getIt<GetCommentsUseCase>(),
          getIt<ToggleLikeUsecase>(),
          getIt<AddCommentUseCase>(),
          getIt<DeletePostUseCase>(),
          getIt<FetchUserDetailsUseCase>(),
      ),
    );

    // Use Cases
    getIt.registerLazySingleton(
      () => GetPostsUseCase(
          getIt<PostRepositoryImpl>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetPostsByIdsUseCase(
          getIt<PostRepositoryImpl>(),
      ),
    );
    getIt.registerLazySingleton(
      () => AddPostUseCase(
          getIt<PostRepositoryImpl>(),
      ),
    );
    getIt.registerLazySingleton(
      () => DeletePostUseCase(
          getIt<PostRepositoryImpl>(),
      ),
    );
    getIt.registerLazySingleton(
      () => ToggleLikeUsecase(
          getIt<PostRepositoryImpl>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetCommentsUseCase(
          getIt<PostRepositoryImpl>(),
      ),
    );
    getIt.registerLazySingleton(
      () => AddCommentUseCase(
          getIt<PostRepositoryImpl>(),
      ),
    );
    getIt.registerLazySingleton(
      () => FetchUserDetailsUseCase(
          getIt<PostRepositoryImpl>(),
      ),
    );




    // Repository
    getIt.registerLazySingleton(
      () => PostRepositoryImpl(
          getIt<PostRemoteDataSourceImpl>(),
      ),
    );


    // Data Sources
    getIt.registerLazySingleton(
      () => PostRemoteDataSourceImpl(
          getIt<ApiHelper>(),
      ),
    );
  }
}