import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../features/main/presentation/pages/main_page.dart';
import '../features/main/domain/entities/post_entity.dart';
import '../features/main/presentation/pages/comments_page.dart';
import '../features/main/presentation/pages/main_page.dart';
import '../features/params/presentation/pages/params_page.dart';
import 'app_route_path.dart';
import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    initialLocation: AppRoute.auth.path,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        builder: (_, __) => const AuthPage(),
        routes: [
          GoRoute(
            path: AppRoute.login.path,
            name: AppRoute.login.name,
            builder: (_, __) => const LoginPage(),
          ),
          GoRoute(
            path: AppRoute.register.path,
            name: AppRoute.register.name,
            builder: (_, __) => const RegisterPage(),
          ),
        ],
      ),
      // GoRoute( //TODO : Deprecated
      //   path: AppRoute.home.path,
      //   name: AppRoute.home.name,
      //   builder: (_, state) {
      //     final params = state.pathParameters;
      //     final user = UserEntity(
      //       username: params["username"],
      //       email: params["email"],
      //       userId: params["user_id"],
      //     );
      //
      //     return HomePage(user: user);
      //   },
      // ),
      GoRoute(
        path: AppRoute.mainPage.path,
        name: AppRoute.mainPage.name,
        builder: (_, state) {
          final params = state.pathParameters;
          final user = UserEntity(
            username: params["username"],
            email: params["email"],
            userId: params["user_id"],
          );

          return MainPage(user: user);
        },
      ),
      GoRoute(
        path: AppRoute.commentsPage.path,
        name: AppRoute.commentsPage.name,
        builder: (_, state) {
          final params = state.pathParameters;
          final post = state.extra as PostEntity;
          final userId = params["user_id"] ?? "";

          return CommentsPage(post: post, userId: userId);
        },
      ),
      GoRoute(
        path: AppRoute.params.path,
        name: AppRoute.params.name,
        builder: (_, state) {
          final params = state.pathParameters;
          final user = UserEntity(
            username: params["username"],
            email: params["email"],
            userId: params["user_id"],
          );

          return ParamsPage(user: user);
        },
      ),
    ],
  );
}