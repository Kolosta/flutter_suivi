import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/blocs/theme/theme_bloc.dart';

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final themeBloc = context.read<ThemeBloc>();
        if (themeBloc.state.isDarkMode) {
          themeBloc.add(LightThemeEvent());
        } else {
          themeBloc.add(DarkThemeEvent());
        }
      },
      child: Text("change_theme".tr()),
    );
  }
}