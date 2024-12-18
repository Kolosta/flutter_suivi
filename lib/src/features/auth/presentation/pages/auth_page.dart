import 'package:easy_localization/easy_localization.dart';
import 'package:tp1_flutter/src/core/extensions/integer_sizedbox_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/app_font.dart';
import '../../../../routes/app_route_path.dart';
import '../../../../widgets/button_widget.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "app_name".tr(),
                      style: AppFont.emphasizeBold,
                    ),
                    const TextSpan(
                      text: "\n",
                    ),
                    TextSpan(
                      text: "title".tr(),
                      style: AppFont.emphasize,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              60.hS,
              SizedBox(
                width: 200.w,
                child: AppButtonWidget(
                  label: "login".tr(),
                  callback: () {
                    context.pushNamed(AppRoute.login.name);
                  },
                  // textStyle: AppFont.emphasizeBold,
                  paddingHorizontal: 40.w,
                  paddingVertical: 10.h,
                ),
              ),
              20.hS,
              SizedBox(
                width: 200.w,
                child: AppButtonWidget(
                  label: "register".tr(),
                  callback: () {
                    context.pushNamed(AppRoute.register.name);
                  },
                  paddingHorizontal: 40.w,
                  paddingVertical: 10.h,
                ),
              ),
              //elevated button avec on pressed vide et un texte
            ],
          ),
        ),
      ),
    );
  }
}