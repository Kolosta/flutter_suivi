import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../../widgets/dialog_widget.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _logout(BuildContext context) {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (_) => AppDialog(title: "exit_message".tr()),
    ).then(
          (value) => value ?? false
          ? context.read<AuthBloc>().add(AuthLogoutEvent())
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _logout(context);
      },
      child: Text("logout".tr()),
    );
  }
}