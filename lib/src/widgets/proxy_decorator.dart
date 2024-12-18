import 'dart:ui';
import 'package:flutter/material.dart';

Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      final double animValue = Curves.easeInOut.transform(animation.value);
      final double scale = lerpDouble(1.0, 1.03, animValue)!; // Scale the card slightly
      return Transform.scale(
        scale: scale,
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      );
    },
    child: child,
  );
}