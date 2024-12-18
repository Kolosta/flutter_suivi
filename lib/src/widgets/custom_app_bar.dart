// lib/src/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../configs/injector/injector.dart';
import '../features/auth/domain/entities/user_entity.dart';
import '../routes/app_route_path.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final UserEntity user;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: context.read<ThemeBloc>().state.isDarkMode ? Colors.white : Colors.white,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.pushNamed(
              AppRoute.params.name,
              pathParameters: {
                "user_id": user.userId ?? "",
                "email": user.email ?? "",
                "username": user.username ?? "",
              },
            );
          },
          splashRadius: 20.0,
          icon: const Icon(Icons.settings),
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}