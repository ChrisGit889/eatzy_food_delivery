import 'package:flutter/material.dart';

enum Anim { elasticIn }

void showSnackBar({
  required BuildContext context,
  required Widget content,
  Color? backgroundColor,
  Anim animationStyle = Anim.elasticIn,
  Duration duration = const Duration(seconds: 1),
  SnackBarAction? action,
}) {
  var style = const ElasticInCurve();

  switch (animationStyle) {
    default:
      {
        style = const ElasticInCurve();
        break;
      }
  }
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      duration: duration,
      action: action,
      backgroundColor: backgroundColor,
    ),
    snackBarAnimationStyle: AnimationStyle(curve: style),
  );
}
