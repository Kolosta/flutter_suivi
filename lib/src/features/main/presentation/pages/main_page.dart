// import 'dart:convert';
// import 'dart:io';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:tp1_flutter/src/features/main/presentation/pages/write_post_page.dart';
//
// import '../../../../configs/injector/injector_conf.dart';
// import '../../../../routes/app_route_path.dart';
// import '../../../auth/domain/entities/post_user_entity.dart';
// import '../bloc/main/post_bloc.dart';
// import '../widgets/post_widget.dart';
//
// class MainPage extends StatefulWidget {
//   final UserEntity user;
//
//   const MainPage({
//     super.key,
//     required this.user
//   });
//
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   late PostBloc _postBloc;
//
//   @override
//   void initState() {
//     super.initState();
//     _postBloc = getIt<PostBloc>()..add(const GetPostsEvent());
//   }
//
//   void _openAddPostPage() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => BlocProvider.value(
//           value: _postBloc,
//           child: WritePostPage(user: widget.user, postBloc: _postBloc,),
//         ),
//       ),
//     );
//   }
//   // void _openAddPostPage() {
//   //   Navigator.of(context).push(
//   //     MaterialPageRoute(
//   //       builder: (context) => WritePostPage(user: widget.user),
//   //     ),
//   //   );
//   // }
//
//   Future<File> _base64ToFile(String base64Str) async {
//     final bytes = base64Decode(base64Str);
//     final dir = await getTemporaryDirectory();
//     final file = File('${dir.path}/temp_image.png');
//     await file.writeAsBytes(bytes);
//     return file;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => _postBloc,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("discussion_thread".tr()),
//           actions: [
//             GestureDetector(
//               onTap: () {
//                 context.pushNamed(
//                   AppRoute.params.name,
//                   pathParameters: {
//                     "user_id": widget.user.userId ?? "",
//                     "email": widget.user.email ?? "",
//                     "username": widget.user.username ?? "",
//                   },
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircleAvatar(
//                   radius: 20,
//                   child: FutureBuilder<File>(
//                     future: _base64ToFile(widget.user.profileImage!),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState ==
//                           ConnectionState.done && snapshot.hasData) {
//                         return CircleAvatar(
//                           radius: 20,
//                           backgroundImage: FileImage(snapshot.data!),
//                         );
//                       } else {
//                         return const CircleAvatar(
//                           radius: 20,
//                           backgroundImage: AssetImage(
//                               'assets/images/default_avatar.jpg'),
//                         );
//                       }
//                     },
//                   ),
//                   // backgroundImage: widget.user.profileImage != null
//                   //     ? NetworkImage(widget.user.profileImage!)
//                   //     : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: BlocBuilder<PostBloc, PostState>(
//           builder: (context, state) {
//             if (state is PostLoadingState) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is PostSuccessState) {
//               return ListView.builder(
//                 itemCount: state.data.length + 1, //+1 pour ajouter un espace à la fin
//                 itemBuilder: (context, index) {
//                   if (index == state.data.length) {
//                     return const SizedBox(height: 80);
//                   }
//                   final post = state.data[index];
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 4.0),
//                     child: PostWidget(
//                       post: post,
//                       userId: widget.user.userId!,
//                       postBloc: _postBloc,
//                     )
//                   );
//                 },
//               );
//             } else {
//               return const Center(child: Text("No posts available"));
//             }
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: _openAddPostPage,
//           child: const Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tp1_flutter/src/features/main/presentation/pages/write_post_page.dart';

import '../../../../configs/injector/injector_conf.dart';
import '../../../../core/utils/logger.dart';
import '../../../../routes/app_route_path.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../bloc/main/post_bloc.dart';
import '../widgets/post_widget.dart';

class MainPage extends StatefulWidget {
  final UserEntity user;

  const MainPage({
    super.key,
    required this.user
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PostBloc _postBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _postBloc = getIt<PostBloc>()..add(const GetPostsEvent());
    _authBloc = getIt<AuthBloc>()..add(AuthCheckSignInStatusEvent());
  }

  void _openAddPostPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _postBloc,
          child: WritePostPage(user: widget.user, postBloc: _postBloc,),
        ),
      ),
    );
  }


  Future<File> _base64ToFile(String base64Str) async {
    final bytes = base64Decode(base64Str);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp_image.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<PostBloc>(create: (_) => _postBloc),
        BlocProvider<AuthBloc>(create: (_) => _authBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("discussion_thread".tr()),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthCheckSignInStatusSuccessState) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        AppRoute.params.name,
                        pathParameters: {
                          "user_id": state.data.userId ?? "",
                          "email": state.data.email ?? "",
                          "username": state.data.username ?? "",
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<File>(
                        future: _base64ToFile(state.data.profileImage!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done && snapshot.hasData) {
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: FileImage(snapshot.data!),
                            );
                          } else {
                            return const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                  'assets/images/default_avatar.jpg'),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostSuccessState) {
              return ListView.builder(
                itemCount: state.data.length + 1,
                //+1 pour ajouter un espace à la fin
                itemBuilder: (context, index) {
                  if (index == state.data.length) {
                    return const SizedBox(height: 80);
                  }
                  final post = state.data[index];
                  return Container(
                      margin: const EdgeInsets.only(bottom: 4.0),
                      child: PostWidget(
                        post: post,
                        userId: widget.user.userId!,
                        postBloc: _postBloc,
                      )
                  );
                },
              );
            } else {
              return const Center(child: Text("No posts available"));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddPostPage,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}