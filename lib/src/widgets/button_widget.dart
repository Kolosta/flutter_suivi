import 'package:flutter/material.dart';

import '../core/themes/app_font.dart';
import '../core/themes/app_color.dart';

enum ButtonType { elevated, text }

class AppButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? callback;
  final ButtonType buttonType;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final Widget? icon;
  final TextStyle? textStyle;

  const AppButtonWidget({
    super.key,
    this.paddingHorizontal,
    this.paddingVertical,
    required this.label,
    required this.callback,
    this.buttonType = ButtonType.elevated,
    this.icon,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {

    final ButtonStyle commonStyle = ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      padding: WidgetStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          horizontal: paddingHorizontal ?? 0,
          vertical: paddingVertical ?? 0,
        ),
      ),
    );

    final child = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              Text(
                label,
              ),
            ],
          )
        : Text(
            label,
          );

    switch (buttonType) {
      case ButtonType.text:
        return TextButton(
          onPressed: callback,
          style: commonStyle,
          child: child,
        );
      default:
        return ElevatedButton(
          onPressed: callback,
          style: commonStyle,
          child: child,
        );
    }
  }
}