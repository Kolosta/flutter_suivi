import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tp1_flutter/src/features/main/presentation/pages/write_post_page.dart';

import '../../../../configs/injector/injector_conf.dart';
import '../../../../routes/app_route_path.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../bloc/post_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _postBloc = getIt<PostBloc>()..add(const GetPostsEvent());
  }

  void _openAddPostPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _postBloc,
          child: WritePostPage(user: widget.user),
        ),
      ),
    );
  }
  // void _openAddPostPage() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => WritePostPage(user: widget.user),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _postBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("discussion_thread".tr()),
          actions: [
            GestureDetector(
              onTap: () {
                context.pushNamed(
                  AppRoute.params.name,
                  pathParameters: {
                    "user_id": widget.user.userId ?? "",
                    "email": widget.user.email ?? "",
                    "username": widget.user.username ?? "",
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.user.profileImage != null
                      ? NetworkImage(widget.user.profileImage!)
                      : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostSuccessState) {
              return ListView.builder(
                itemCount: state.data.length + 1, //+1 pour ajouter un espace à la fin
                itemBuilder: (context, index) {
                  if (index == state.data.length) {
                    return const SizedBox(height: 80);
                  }
                  final post = state.data[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4.0),
                    child: PostWidget(
                      post: post,
                      userId: widget.user.userId!
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