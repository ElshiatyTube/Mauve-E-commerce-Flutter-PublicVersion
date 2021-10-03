import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/shared/style/colors.dart';

class DefaultButtonView extends StatelessWidget {
  final double width;
  final Color background;
  final bool isUpperCase;
  final double radius;

  final VoidCallback function;
  final String text;

  const DefaultButtonView(
      {Key? key,
      this.width = double.infinity,
      this.background = blackColor,
      this.isUpperCase = true,
      this.radius = 0.0,
      required this.function,
        required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text.toLowerCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.0,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
    );;
  }
}
